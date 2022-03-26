class Libtrace < Formula
  desc "Library for trace processing supporting multiple inputs"
  homepage "https://research.wand.net.nz/software/libtrace.php"
  url "https://research.wand.net.nz/software/libtrace/libtrace-4.0.17.tar.bz2"
  sha256 "5db6572467122581c44ce505327d7882bc21d9bad4bee8c57a147cc93a29d1ac"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?libtrace[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "b1b7949b37538a37dd582e68bb5dad9f81e4f1f4046747e7752479aff77e97f6"
    sha256 cellar: :any, arm64_big_sur:  "1939f5eff2012583d368e417ea50ea1e324c99a7f4f91285ad788183ecdce8fa"
    sha256 cellar: :any, monterey:       "46b90e5450699e230f8927681a4aa14afa2384a07e5688f7328cef16ae266aa3"
    sha256 cellar: :any, big_sur:        "3ea87a19d8421ff02650581699caeccc9cff21aeb309dee19a7b74bdd47c63ff"
    sha256 cellar: :any, catalina:       "89febb4122bbe7cd16fc3607ec8cebb242a097603db98da65f05ee733e794bd0"
    sha256 cellar: :any, mojave:         "4148146586b780f70814f23aeaeb28ce0a07ddd26ca9abedd77f8673e5b75e0a"
  end

  depends_on "openssl@1.1"
  depends_on "wandio"

  uses_from_macos "flex" => :build
  uses_from_macos "libpcap"

  resource "8021x.pcap" do
    url "https://github.com/LibtraceTeam/libtrace/raw/9e82eabc39bc491c74cc4215d7eda5f07b85a8f5/test/traces/8021x.pcap"
    sha256 "aa036e997d7bec2fa3d387e3ad669eba461036b9a89b79dcf63017a2c4dac725"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libtrace.h>
      #include <inttypes.h>
      #include <stdio.h>
      #include <getopt.h>
      #include <stdlib.h>
      #include <string.h>

      double lastts = 0.0;
      uint64_t v4_packets=0;
      uint64_t v6_packets=0;
      uint64_t udp_packets=0;
      uint64_t tcp_packets=0;
      uint64_t icmp_packets=0;
      uint64_t ok_packets=0;

      static void per_packet(libtrace_packet_t *packet)
      {
        /* Packet data */
        uint32_t remaining;
        /* L3 data */
        void *l3;
        uint16_t ethertype;
        /* Transport data */
        void *transport;
        uint8_t proto;
        /* Payload data */
        void *payload;

        if (lastts < 1)
          lastts = trace_get_seconds(packet);

        if (lastts+1.0 < trace_get_seconds(packet)) {
          ++lastts;
          printf("%.03f,",lastts);
          printf("%"PRIu64",%"PRIu64",",v4_packets,v6_packets);
          printf("%"PRIu64",%"PRIu64",%"PRIu64,icmp_packets,tcp_packets,udp_packets);
          printf("\\n");
          v4_packets=v6_packets=0;
          icmp_packets=tcp_packets=udp_packets=0;
        }

        l3 = trace_get_layer3(packet,&ethertype,&remaining);

        if (!l3)
          /* Probable ARP or something */
          return;

        /* Get the UDP/TCP/ICMP header from the IPv4_packets/IPv6_packets packet */
        switch (ethertype) {
          case 0x0800:
            transport = trace_get_payload_from_ip(
                (libtrace_ip_t*)l3,
                &proto,
                &remaining);
            if (!transport)
              return;
            ++v4_packets;
            break;
          case 0x86DD:
            transport = trace_get_payload_from_ip6(
                (libtrace_ip6_t*)l3,
                &proto,
                &remaining);
            if (!transport)
              return;
            ++v6_packets;
            break;
          default:
            return;
        }

        /* Parse the udp_packets/tcp_packets/icmp_packets payload */
        switch(proto) {
          case 1:
            ++icmp_packets;
            return;
          case 6:
            payload = trace_get_payload_from_tcp(
                (libtrace_tcp_t*)transport,
                &remaining);
            if (!payload)
              return;

            ++tcp_packets;
            break;
          case 17:

            payload = trace_get_payload_from_udp(
                (libtrace_udp_t*)transport,
                &remaining);
            if (!payload)
              return;
            ++udp_packets;
            break;
          default:
            return;
        }
        ++ok_packets;
      }

      static void usage(char *argv0)
      {
        fprintf(stderr,"usage: %s [ --filter | -f bpfexp ]  [ --snaplen | -s snap ]\\n\\t\\t[ --promisc | -p flag] [ --help | -h ] [ --libtrace-help | -H ] libtraceuri...\\n",argv0);
      }

      int main(int argc, char *argv[])
      {
        libtrace_t *trace;
        libtrace_packet_t *packet;
        libtrace_filter_t *filter=NULL;
        int snaplen=-1;
        int promisc=-1;

        while(1) {
          int option_index;
          struct option long_options[] = {
            { "filter",   1, 0, 'f' },
            { "snaplen",    1, 0, 's' },
            { "promisc",    1, 0, 'p' },
            { "help",   0, 0, 'h' },
            { "libtrace-help",  0, 0, 'H' },
            { NULL,     0, 0, 0 }
          };

          int c= getopt_long(argc, argv, "f:s:p:hH",
              long_options, &option_index);

          if (c==-1)
            break;

          switch (c) {
            case 'f':
              filter=trace_create_filter(optarg);
              break;
            case 's':
              snaplen=atoi(optarg);
              break;
            case 'p':
              promisc=atoi(optarg);
              break;
            case 'H':
              trace_help();
              return 1;
            default:
              fprintf(stderr,"Unknown option: %c\\n",c);
              /* FALL THRU */
            case 'h':
              usage(argv[0]);
              return 1;
          }
        }

        if (optind>=argc) {
          fprintf(stderr,"Missing input uri\\n");
          usage(argv[0]);
          return 1;
        }

        while (optind<argc) {
          trace = trace_create(argv[optind]);
          ++optind;

          if (trace_is_err(trace)) {
            trace_perror(trace,"Opening trace file");
            return 1;
          }

          if (snaplen>0)
            if (trace_config(trace,TRACE_OPTION_SNAPLEN,&snaplen)) {
              trace_perror(trace,"ignoring: ");
            }
          if (filter)
            if (trace_config(trace,TRACE_OPTION_FILTER,filter)) {
              trace_perror(trace,"ignoring: ");
            }
          if (promisc!=-1) {
            if (trace_config(trace,TRACE_OPTION_PROMISC,&promisc)) {
              trace_perror(trace,"ignoring: ");
            }
          }

          if (trace_start(trace)) {
            trace_perror(trace,"Starting trace");
            trace_destroy(trace);
            return 1;
          }

          packet = trace_create_packet();

          while (trace_read_packet(trace,packet)>0) {
            per_packet(packet);
          }

          trace_destroy_packet(packet);

          if (trace_is_err(trace)) {
            trace_perror(trace,"Reading packets");
          }

          trace_destroy(trace);
        }
              if (filter) {
                      trace_destroy_filter(filter);
              }
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ltrace", "-o", "test"
    resource("8021x.pcap").stage testpath
    system "./test", testpath/"8021x.pcap"
  end
end

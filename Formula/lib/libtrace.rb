class Libtrace < Formula
  desc "Library for trace processing supporting multiple inputs"
  homepage "https://github.com/LibtraceTeam/libtrace"
  url "https://github.com/LibtraceTeam/libtrace/archive/refs/tags/4.0.32-1.tar.gz"
  version "4.0.32"
  sha256 "97ae2ae44c3603957f75f41ce1124698057ebc24ee0fa36f5c902bbb23d9ec2e"
  license all_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.gsub(/-1$/, "") }
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b4f8f78341237cbf0f5b787adfa0dc5738bec660f8006e1db81366b02ed7cbe1"
    sha256 cellar: :any, arm64_sequoia: "72218d4cf4941ef363860b63e9116f5f10bc9a90cde61eb88caf87b5696c717d"
    sha256 cellar: :any, arm64_sonoma:  "0750fd5ca6eed2b58e0cd7d161664af9c1ec7b691436e4cce713e8bc2503a900"
    sha256 cellar: :any, sonoma:        "6cdc0131a7b7fef52374ea62f6ded2620501ca3c47f6a2301ebc13301a5e8819"
    sha256 cellar: :any, arm64_linux:   "d23c416965ede20d1fdadb606fc7c2ead36ddf0231c8817b074c81c3592d7b87"
    sha256 cellar: :any, x86_64_linux:  "d90f930894133f34e04f7945ac2494aab204d9deb601ff59b82fcaf097ace634"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"
  depends_on "wandio"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libpcap"
  uses_from_macos "ncurses"

  def install
    system "./bootstrap.sh"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    resource "homebrew-8021x.pcap" do
      url "https://github.com/LibtraceTeam/libtrace/raw/9e82eabc39bc491c74cc4215d7eda5f07b85a8f5/test/traces/8021x.pcap"
      sha256 "aa036e997d7bec2fa3d387e3ad669eba461036b9a89b79dcf63017a2c4dac725"
    end

    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ltrace", "-o", "test"
    resource("homebrew-8021x.pcap").stage testpath
    system "./test", testpath/"8021x.pcap"
  end
end

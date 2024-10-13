class Knot < Formula
  desc "High-performance authoritative-only DNS server"
  homepage "https://www.knot-dns.cz/"
  url "https://secure.nic.cz/files/knot-dns/knot-3.4.0.tar.xz"
  sha256 "2730b11398944faa5151c51b0655cf26631090343c303597814f2a57df424736"
  license all_of: ["GPL-3.0-or-later", "0BSD", "BSD-3-Clause", "LGPL-2.0-or-later", "MIT"]

  livecheck do
    url "https://secure.nic.cz/files/knot-dns/"
    regex(/href=.*?knot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "189a055d1c3786b81bcc6163c0ad3590be8688a936242db45e89a8e63c089017"
    sha256 arm64_sonoma:   "f49c6ab26df4e8035ca51efa8f7303ef3a7a83cccd88e0a3b2e900bb7a4844f4"
    sha256 arm64_ventura:  "199069645af7ea674609b299319130b85606c328c295490dfba2cce7c5023fe1"
    sha256 arm64_monterey: "bab431230b2b292e20a9450854cb69ebf0be1e670a808f53fa3c406a2abc2086"
    sha256 sonoma:         "fe2af38840f5cf891a1ce385f0c8d7289b76a3d4a27fee619400285222eb4f16"
    sha256 ventura:        "20e9f944d141010aa21063aa393d05f4f9148a00af94094d495f474b01356d54"
    sha256 monterey:       "748ef7e36b58f7067c2612d5d9893db496585c03b8b6ce81a07f57145d1a5c36"
    sha256 x86_64_linux:   "8dd28478b6d2bfb27e954ff056653db9e8a2acd82cc2dde8cb663c985952145b"
  end

  head do
    url "https://gitlab.nic.cz/knot/knot-dns.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "fstrm"
  depends_on "gnutls"
  depends_on "libidn2"
  depends_on "libnghttp2"
  depends_on "lmdb"
  depends_on "protobuf-c"
  depends_on "userspace-rcu"

  uses_from_macos "libedit"

  def install
    # https://gitlab.nic.cz/knot/knot-dns/-/blob/master/src/knot/modules/rrl/kru-avx2.c
    ENV.runtime_cpu_detection if Hardware::CPU.intel?

    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--with-configdir=#{etc}",
                          "--with-storage=#{var}/knot",
                          "--with-rundir=#{var}/run/knot",
                          "--with-module-dnstap",
                          "--enable-dnstap",
                          "--enable-quic",
                          *std_configure_args

    inreplace "samples/Makefile", "install-data-local:", "disable-install-data-local:"

    system "make"
    system "make", "install"
    system "make", "install-singlehtml"

    (buildpath/"knot.conf").write(knot_conf)
    etc.install "knot.conf"
  end

  def post_install
    (var/"knot").mkpath
  end

  def knot_conf
    <<~EOS
      server:
        rundir: "#{var}/knot"
        listen: [ "0.0.0.0@53", "::@53" ]

      log:
        - target: "stderr"
          any: "info"

      control:
        listen: "knot.sock"

      template:
        - id: "default"
          storage: "#{var}/knot"
    EOS
  end

  service do
    run opt_sbin/"knotd"
    require_root true
    input_path "/dev/null"
    log_path "/dev/null"
    error_log_path var/"log/knot.log"
  end

  test do
    system bin/"kdig", "@94.140.14.140", "www.knot-dns.cz", "+quic"
    system bin/"khost", "brew.sh"
    system sbin/"knotc", "conf-check"
  end
end

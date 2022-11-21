class Knot < Formula
  desc "High-performance authoritative-only DNS server"
  homepage "https://www.knot-dns.cz/"
  url "https://secure.nic.cz/files/knot-dns/knot-3.2.3.tar.xz"
  sha256 "f736ef284358923e312f8e1e3c6ce7c97b20965b09eb65705e9f7e3d5e9a9d79"
  license all_of: ["GPL-3.0-or-later", "0BSD", "BSD-3-Clause", "LGPL-2.0-or-later", "MIT"]

  livecheck do
    url "https://secure.nic.cz/files/knot-dns/"
    regex(/href=.*?knot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "74efad115384d07983a418f7567171ab8fca9c645a369c9551a3a488810ddfdb"
    sha256 arm64_monterey: "d0954dff5df826f34231cdc3c0d8189eef3661bd03c1c83933e29180442afad0"
    sha256 arm64_big_sur:  "435fca1b64b2f672a227c0333a94c9a8e4dfe50b0ed9fee9c5ab1335d8f957d9"
    sha256 ventura:        "889e8c48c7bc74ddab94c50631df55ba653d1d03b003fc50972f81d3e354e879"
    sha256 monterey:       "20cd6b962e97cd3f5a5227ebfa6d689c51aa660dc275d9e9d81c0748fd8551d7"
    sha256 big_sur:        "8c2f4b267c6f1b5b0c4f979c9434430e963df049dc964af459d7ba17233ef607"
    sha256 catalina:       "01b7a4bf22b85a66714d2675adf0db53e25e5e73ba55c4ae2ed93dc0bc2039a0"
    sha256 x86_64_linux:   "14487417fb704b678ae17fb3236a13d1b78c7716f5f8be260cab7d1388ea115d"
  end

  head do
    url "https://gitlab.labs.nic.cz/knot/knot-dns.git"

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
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-configdir=#{etc}",
                          "--with-storage=#{var}/knot",
                          "--with-rundir=#{var}/run/knot",
                          "--prefix=#{prefix}",
                          "--with-module-dnstap",
                          "--enable-dnstap",
                          "--enable-quic"

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

  plist_options startup: true
  service do
    run opt_sbin/"knotd"
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

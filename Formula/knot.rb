class Knot < Formula
  desc "High-performance authoritative-only DNS server"
  homepage "https://www.knot-dns.cz/"
  url "https://secure.nic.cz/files/knot-dns/knot-3.1.5.tar.xz"
  sha256 "2da6e50b0662297d55f80e349568224e07fe88cad20bee1d2e22f54bb32da064"
  license all_of: ["GPL-3.0-or-later", "0BSD", "BSD-3-Clause", "LGPL-2.0-or-later", "MIT"]
  revision 1

  livecheck do
    url "https://secure.nic.cz/files/knot-dns/"
    regex(/href=.*?knot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "32328bcb82ad635eaa41cd9f9827a8d932afbc661bbc24775a405e5af9e57df7"
    sha256 arm64_big_sur:  "4b4b67241a382475c0546f2a664518436ab13bb73f5544aff1dfcb6015187d43"
    sha256 monterey:       "27a112ffc321fbef90baa55f937e8b2d17c84ddbf39466bd6a6a2fe1daffdfd8"
    sha256 big_sur:        "065fab3a80f305b392d5096bc3d87193d3ce8baf34f8d399489d1afdd654cd79"
    sha256 catalina:       "f41b04cf5103cae87d31adeedd7ee54cc948ad9bce58bd79cadb1ce32e3e6be8"
    sha256 x86_64_linux:   "026821bc22babd0f8a589ab43fd7bb13de3fee779640854123599a9cb1af02cf"
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
                          "--enable-dnstap"

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
    system bin/"kdig", "www.knot-dns.cz"
    system bin/"khost", "brew.sh"
    system sbin/"knotc", "conf-check"
  end
end

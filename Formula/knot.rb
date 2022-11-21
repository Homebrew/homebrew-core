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
    sha256 arm64_ventura:  "c6133861ab2b7fe73c813b5145e8dba409d4f84c1611e32ed48ad79a2424d878"
    sha256 arm64_monterey: "4765191a7dbec567a449247a4dffde51c06e540ccb733740e45f5aca1fba65e9"
    sha256 arm64_big_sur:  "2d1a60361646b3544aea5cd4f6686ad5345e078eab5093dc54d30bf4049d9849"
    sha256 monterey:       "3ec28d52e7e32c93af0e4fe9c550876ddf6c252c957d5acbe5e52adeb85ab4df"
    sha256 big_sur:        "8c1ecef3ce46d4d38fb428179e0c5ab8c36c79fd2c5962e90a4c40e6460c4f90"
    sha256 catalina:       "571e5ddb8a6b64cad3a359f84fa01deebe32dd8f8de4cd578bf716b72d06424e"
    sha256 x86_64_linux:   "8c81c2d182517061edf8f7f85b6534c628bf8ca1d4165e67509bc3636a1713fc"
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

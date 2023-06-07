class Knot < Formula
  desc "High-performance authoritative-only DNS server"
  homepage "https://www.knot-dns.cz/"
  url "https://secure.nic.cz/files/knot-dns/knot-3.2.7.tar.xz"
  sha256 "d3b7872ac8aa80f7f54ddb1bb3b1e2f90ec55f7270a2c4a9338eab42b7d2767b"
  license all_of: ["GPL-3.0-or-later", "0BSD", "BSD-3-Clause", "LGPL-2.0-or-later", "MIT"]

  livecheck do
    url "https://secure.nic.cz/files/knot-dns/"
    regex(/href=.*?knot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "62b347cb03ba4202a2f8b41d7e998e7177de20f9029ca7910634fa65aa0225d3"
    sha256 arm64_monterey: "47981a1e439c19809eb4f3e98fdabed9aa7074aa69728f9e740ff4fb19f8f18b"
    sha256 arm64_big_sur:  "6f4a10530b16a7886b20140eb16657f81115e0c8d62c6c90db579cf1fa419770"
    sha256 ventura:        "f5fc29d9d754643128d77e51e879a665e16989beeb1dd5da1150c5669d4b75a0"
    sha256 monterey:       "1e08eeb9e8f1cbdbd3d6c2669d903f6ae6c19248d7f139a564951de7bfb881a4"
    sha256 big_sur:        "f12167e00b58c78c6e355f40b0873bf234a5307b3dbe189ca14542173710a2f3"
    sha256 x86_64_linux:   "6ffd92a6aa166f372178de1a8f413355b958da8d4a25dbd2d0643cac51ee40ea"
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

class Knot < Formula
  desc "High-performance authoritative-only DNS server"
  homepage "https://www.knot-dns.cz/"
  url "https://secure.nic.cz/files/knot-dns/knot-3.2.6.tar.xz"
  sha256 "ac124fb17dbc4ac5310a30a396245a6ba304b3c89abed0f8a47d727462c8da4d"
  license all_of: ["GPL-3.0-or-later", "0BSD", "BSD-3-Clause", "LGPL-2.0-or-later", "MIT"]

  livecheck do
    url "https://secure.nic.cz/files/knot-dns/"
    regex(/href=.*?knot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "d2b3c6c65f9e3981a9a5b0eae0609ec625cb773cbf9bfdd99bbb5967832ffdc6"
    sha256 arm64_monterey: "6b1f039dfa33f9f0422908310293fd0d5e3a00ee1c1ef2fc77a150fc99dcfa4b"
    sha256 arm64_big_sur:  "78bca8562663a2c7f2feaf0054328eed42cce850a456262894d7746b660e9de8"
    sha256 ventura:        "afab45005aa9f0e37cfff8f8017594127c8400b246ba2d7198ec675674e7b1aa"
    sha256 monterey:       "a1c1ea17b2ade14c46cf1cf04d7a019bd6b797d501cb433411c8b8ac5dc09eb8"
    sha256 big_sur:        "be73298e155caf9d986863bc7e62cb3c451eb4c33d08750d40bf0c7d36a8543a"
    sha256 x86_64_linux:   "fe91873995cfb3100d603621225ab93febc71da4f08a25abd7a49c45789ef4f0"
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

class Knot < Formula
  desc "High-performance authoritative-only DNS server"
  homepage "https://www.knot-dns.cz/"
  url "https://knot-dns.nic.cz/release/knot-3.4.2.tar.xz"
  sha256 "d835285c1057d45effa1479cfe1f107a50e83d11c1c6d36f270deda88799883e"
  license all_of: ["GPL-3.0-or-later", "0BSD", "BSD-3-Clause", "LGPL-2.0-or-later", "MIT"]

  livecheck do
    url "https://www.knot-dns.cz/download/"
    regex(/href=.*?knot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "c99d652c3e0778927339e1a581ed85e1267dd47f53f0ae46901af2bd1a21b941"
    sha256 arm64_sonoma:  "b1375b982f90f121a3465b67f4520ace7b1be0a689d95d519f877458875232f0"
    sha256 arm64_ventura: "63d2d784d8abfad6ae8506a0519207c1cc56c2fc29747f07f1ed5b5d42cd0521"
    sha256 sonoma:        "1bb0a2c6fd6f0f8dc76a6beb695621b5b43819c5811175999ec5e84a239da1d2"
    sha256 ventura:       "173e37d84d4a91c5f39b84b82ba7fbfd90d75c4b28380f287d714663876c3b55"
    sha256 x86_64_linux:  "327db5594c0d0d87cfadc3d5b9fcde83a617262a7cb963a858eb276549cd2e9a"
  end

  head do
    url "https://gitlab.nic.cz/knot/knot-dns.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
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
    input_path File::NULL
    log_path File::NULL
    error_log_path var/"log/knot.log"
  end

  test do
    system bin/"kdig", "@94.140.14.140", "www.knot-dns.cz", "+quic"
    system bin/"khost", "brew.sh"
    system sbin/"knotc", "conf-check"
  end
end

class Knot < Formula
  desc "High-performance authoritative-only DNS server"
  homepage "https://www.knot-dns.cz/"
  url "https://knot-dns.nic.cz/release/knot-3.4.7.tar.xz"
  sha256 "dd346ca6f3afabcdc5e9ba09dd667b010590bb66a42f4541021fb9d6f073dacc"
  license all_of: ["GPL-3.0-or-later", "0BSD", "BSD-3-Clause", "LGPL-2.0-or-later", "MIT"]

  livecheck do
    url "https://www.knot-dns.cz/download/"
    regex(/href=.*?knot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "1dc4d7ee983b698f773fa5d55a8f0bbe9a328a335966e632f627823c1271c95b"
    sha256 arm64_sonoma:  "b9d60eb58dc99bb7bd452488aa32baf855a4a453804efe60dc0494d9c95c9480"
    sha256 arm64_ventura: "08e467b47054a840ccfc604113df50af71f0499c78a829fc04c77ec8f96c72dd"
    sha256 sonoma:        "924d0d12a0d7b17716b8d4d373441b048b07a85d8e7a4af59176dc02c3a7660d"
    sha256 ventura:       "86e4f45035be1f9a197fbf9cd23351c904a1c6c4d1b375025192ec08800ba0c7"
    sha256 arm64_linux:   "f1f7baf441b646da5acecf8240d9ea865c1dd6413b170a6e5762da937be279c5"
    sha256 x86_64_linux:  "11d5ee8ee5370e2fd1dcececdb6b5e46531306995bda35f5131265a5108680fa"
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
        listen: [ "127.0.0.1@53", "::@53" ]

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

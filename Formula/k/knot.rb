class Knot < Formula
  desc "High-performance authoritative-only DNS server"
  homepage "https://www.knot-dns.cz/"
  url "https://knot-dns.nic.cz/release/knot-3.4.5.tar.xz"
  sha256 "359af70afafa7ccaa18439a7c1eb35270ff9eece81d0756ae4ca716b1433cb4b"
  license all_of: ["GPL-3.0-or-later", "0BSD", "BSD-3-Clause", "LGPL-2.0-or-later", "MIT"]

  livecheck do
    url "https://www.knot-dns.cz/download/"
    regex(/href=.*?knot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "fb2a03707bca3a30c4920b387fc26b5bfea3a04194ed0373237d69dd8f5808b2"
    sha256 arm64_sonoma:  "70c3e6f73fc410caae5d8b61a229f8c26b678d3e7d92ced6eb7e385c79c95026"
    sha256 arm64_ventura: "781ee000ccc02d1b49270855c65d622c24a44fbf7379e8bffc908155ef09e20a"
    sha256 sonoma:        "d35aeb28f9d0f3793e0d77c91e8a015584f252981cdfb33aa6f5c0b76820169c"
    sha256 ventura:       "a46e505e12ba13083f5211cbd0ddec4a1c92d434c4572c33dcc8274a746619f7"
    sha256 arm64_linux:   "9e36f319c1c0b26372ade4e49936fcf0e7db00aabae7ec187a789e6c382f6dc7"
    sha256 x86_64_linux:  "c58465073d06cb6ad06de3830b35f12650d5e1741e3026b18fad27277cbfbcb3"
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

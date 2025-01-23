class Knot < Formula
  desc "High-performance authoritative-only DNS server"
  homepage "https://www.knot-dns.cz/"
  url "https://knot-dns.nic.cz/release/knot-3.4.4.tar.xz"
  sha256 "e7d9d6de97f21bf33e907bd986a4038025f394879af0a5fd19787203ac3b2131"
  license all_of: ["GPL-3.0-or-later", "0BSD", "BSD-3-Clause", "LGPL-2.0-or-later", "MIT"]

  livecheck do
    url "https://www.knot-dns.cz/download/"
    regex(/href=.*?knot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "346b5a502d86e5a9700d7be63843f4f9be5085357074b1744af65b392cedf035"
    sha256 arm64_sonoma:  "3bb62cfef4baa86955b3c1179e589874403a9bd366b93fc16cc8add0f50b5328"
    sha256 arm64_ventura: "93cbea4f44ea2a25ca587123e6120d751e9373d39b86d9a4e0e90b671613b42e"
    sha256 sonoma:        "e5d65d472ba886057e85f8c9af7d457f27e1c25d0aaac17bbdf468bc89fb49bd"
    sha256 ventura:       "1225ce70b362e06d102b3f87b98c18e4b0fadf875c154c5b99906f3e531ee6bc"
    sha256 x86_64_linux:  "e04947ad31118df8c7e5b1bcbc427ee20cd93485bfdb4533ae188e1d30daafd9"
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

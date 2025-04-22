class Libp11 < Formula
  desc "PKCS#11 wrapper library in C"
  homepage "https://github.com/OpenSC/libp11/wiki"
  url "https://github.com/OpenSC/libp11/releases/download/libp11-0.4.13/libp11-0.4.13.tar.gz"
  sha256 "d25dd9cff1b623e12d51b6d2c100e26063582d25c9a6f57c99d41f2da9567086"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/^libp11[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "977ad78d2a417ee9375ce0964571619850c0341359ec1cf8ccd29e5fa739e974"
    sha256 cellar: :any,                 arm64_sonoma:  "904fc18f308574764d577787969935815cb4859063772537ab8d933dfb07bfe2"
    sha256 cellar: :any,                 arm64_ventura: "621c22fec9d9f4a3f17b370bd92e97ca1ece49e7a813e863d64db4ed845105cc"
    sha256 cellar: :any,                 sonoma:        "e010e9fbaf03cc911d790fdbcd555f59f96babeb9cb6726e3df72f4f5cf08f2e"
    sha256 cellar: :any,                 ventura:       "f2fdf3fe55448304d0699d293f5ae42670d3a66d78007d2178d147455a95a1df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1ff1243ca21e160c7e34a254deef46a741561b45d9cbf356ec110cd535b97fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b5c9f823614a8048d5d01badef22552f87348814f0286a76119481f72acf940"
  end

  head do
    url "https://github.com/OpenSC/libp11.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libtool"
  depends_on "openssl@3"

  def install
    openssl = deps.find { |d| d.name.match?(/^openssl/) }
                  .to_formula
    enginesdir = Utils.safe_popen_read("pkgconf", "--variable=enginesdir", "libcrypto").chomp
    enginesdir.sub!(openssl.prefix.realpath, prefix)

    system "./bootstrap" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--with-enginesdir=#{enginesdir}",
                          *std_configure_args
    system "make", "install"
    pkgshare.install "examples/auth.c"
  end

  test do
    system ENV.cc, pkgshare/"auth.c", "-I#{Formula["openssl@3"].include}",
                   "-L#{lib}", "-L#{Formula["openssl@3"].lib}",
                   "-lp11", "-lcrypto", "-o", "test"
  end
end

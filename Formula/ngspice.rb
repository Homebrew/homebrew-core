class Ngspice < Formula
  desc "Spice circuit simulator"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/38/ngspice-38.tar.gz"
  sha256 "2c3e22f6c47b165db241cf355371a0a7558540ab2af3f8b5eedeeb289a317c56"
  license :cannot_represent
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/ngspice[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "47d12fc23fbbd5790eed5901cb40b44e8f4cecface33fd4e6627175b11cf7347"
    sha256 arm64_monterey: "b9ea5fe131b79626bce3e45ed9164d9a82c6b9bf9b200cde968e7e54e255c3cc"
    sha256 arm64_big_sur:  "5b3a0017abf06f683abadf300f57e3c6b0bda63ac33e78c6579b9eb0e0ea4787"
    sha256 ventura:        "9d561a78aa04a69bebb38da569f088d8a61bd893430f8981ba9f1aa5be423d82"
    sha256 monterey:       "afcbe1770ae25464eff3c5f6f40c1946992e634b387957cf94826a79ec8db9c2"
    sha256 big_sur:        "155d852cbf551404e160f45871d251f9832e6f8ea0992f8e2f7093ce4f7be20b"
    sha256 catalina:       "70a9f330cfee34bbcd6666384faeb309f8d778ab3d1f51883deeb14ceae5b4c1"
    sha256 x86_64_linux:   "8d791ed65ceb5c9de344d0b94a7a5b00f35d2358c7b61ead3be3aaa1c564e350"
  end

  head do
    url "https://git.code.sf.net/p/ngspice/ngspice.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "libtool" => :build
  end

  depends_on "fftw"
  depends_on "libngspice"
  depends_on "readline"

  def install
    system "./autogen.sh" if build.head?

    args = %w[
      --disable-dependency-tracking
      --disable-silent-rules
      --with-readline=yes
      --enable-xspice
      --without-x
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"

    # fix references to libs
    inreplace pkgshare/"scripts/spinit", lib/"ngspice/", Formula["libngspice"].opt_lib/"ngspice/"

    # remove conflict lib files with libngspice
    rm_rf Dir[lib/"ngspice"]
  end

  test do
    (testpath/"test.cir").write <<~EOS
      RC test circuit
      v1 1 0 1
      r1 1 2 1
      c1 2 0 1 ic=0
      .tran 100u 100m uic
      .control
      run
      quit
      .endc
      .end
    EOS
    system "#{bin}/ngspice", "test.cir"
  end
end

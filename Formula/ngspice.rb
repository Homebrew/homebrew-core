class Ngspice < Formula
  desc "Spice circuit simulator"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/36/ngspice-36.tar.gz"
  sha256 "4f818287efba245341046635b757ae81f879549b326a4316b5f6e697aa517f8c"

  livecheck do
    url :stable
    regex(%r{url=.*?/ngspice[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "3d9a7e0ce809f0ca5354a6ec9a48255f71ecdec6f9f3a850b449cfefb966547b"
    sha256 arm64_big_sur:  "0dbb98975e4613a0615ca03bb37da9b4907bf4e9c517f80fcbefb190a528170e"
    sha256 monterey:       "8d89c5fdab637c015823ac08171da34e21661e2d6717df850a3bd6908272a85b"
    sha256 big_sur:        "4faccb580e3fa378262a8f9f3d4b20c28af2f052424b30fd4ea0466ad09986b4"
    sha256 catalina:       "d26cd0c032de8caaa2f4010043417e728df17c4e271dc0a4acb911a413b90f36"
    sha256 mojave:         "1fc7fa69b46f1d95c8473fcca45f1b7faac6af1296d1cf22d0d99c3a3968234b"
    sha256 x86_64_linux:   "c0d0de7275a902a088abfeb4d04ad8b99ccfb11df9800b08caf95ad0bad74ba5"
  end

  head do
    url "https://git.code.sf.net/p/ngspice/ngspice.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "libtool" => :build
  end

  depends_on "fftw"
  depends_on "readline"

  def install
    system "./autogen.sh" if build.head?

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-readline=yes
      --enable-xspice
      --without-x
    ]

    system "./configure", *args
    system "make", "install"

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

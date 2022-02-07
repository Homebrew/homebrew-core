class Dcraw < Formula
  desc "Digital camera RAW photo decoding software"
  homepage "https://www.dechifro.org/dcraw/"
  url "https://www.dechifro.org/dcraw/archive/dcraw-9.28.0.tar.gz"
  mirror "https://mirrorservice.org/sites/distfiles.macports.org/dcraw/dcraw-9.28.0.tar.gz"
  sha256 "2890c3da2642cd44c5f3bfed2c9b2c1db83da5cec09cc17e0fa72e17541fb4b9"
  revision 1

  livecheck do
    url "https://distfiles.macports.org/dcraw/"
    regex(/href=.*?dcraw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "54aef6cd7f83a16ad41f6094d2a1821bae08b307dcc2fcf40a83705c195f53d4"
    sha256 cellar: :any,                 arm64_big_sur:  "743f571022d74442fa2d81309c916ff665114303a4e916d1b9a970c50ddb71e3"
    sha256 cellar: :any,                 monterey:       "963aaef6e14ec562514c95e81f9dfd5ef3e94ffc27815f75d4b3819f394145c5"
    sha256 cellar: :any,                 big_sur:        "fc0e1b6d2ac47be836929a68ee33d693bb2e455c4ecdd1dee7beafb3a5c123c6"
    sha256 cellar: :any,                 catalina:       "df26056a9b3374154b499b4dbdee4a1417a58a15cffe22ac40f095747ee1f8a7"
    sha256 cellar: :any,                 mojave:         "4673710b946c4fa3eb47d0b693b380e8abb636202ce86e0e13372a8539141bd8"
    sha256 cellar: :any,                 high_sierra:    "21f31347e500f314a1f2e6fe03f0d6009b25fa5bd9f1f339b0fe77fc38050e81"
    sha256 cellar: :any,                 sierra:         "dc99d6de1166a3f4fa66d23b798dad9a58e0fac24f72c02ab38ea32e74b30a9e"
    sha256 cellar: :any,                 el_capitan:     "022f85e8da7b4cd8c68d7251d39bf3084ec28a15cb859d9cfe49bd439e312466"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df4ae1286e4b5cadcc8db82146d0ef622eda6e8d5e494e00a1ad53961c3cf32f"
  end

  depends_on "jasper"
  depends_on "jpeg"
  depends_on "little-cms2"

  def install
    ENV.append_to_cflags "-I#{HOMEBREW_PREFIX}/include -L#{HOMEBREW_PREFIX}/lib"
    system ENV.cc, "-o", "dcraw", ENV.cflags, "dcraw.c", "-lm", "-ljpeg", "-llcms2", "-ljasper"
    bin.install "dcraw"
    man1.install "dcraw.1"
  end

  test do
    assert_match "\"dcraw\" v9", shell_output("#{bin}/dcraw", 1)
  end
end

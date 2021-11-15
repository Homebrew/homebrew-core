class Dosbox < Formula
  desc "DOS Emulator"
  homepage "https://www.dosbox.com/"
  url "https://downloads.sourceforge.net/project/dosbox/dosbox/0.74-3/dosbox-0.74-3.tar.gz"
  sha256 "c0d13dd7ed2ed363b68de615475781e891cd582e8162b5c3669137502222260a"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "17d82e44047546d286b0674ba2acff78432f57f67c72111cf9ad6c0780ec43cb"
    sha256 cellar: :any,                 arm64_big_sur:  "999bf1d034d6cd7eae80c5439fc07bd5681ccc315edd872872050adcf76dffc7"
    sha256 cellar: :any,                 monterey:       "9c8543fa951eaf84a4466641f4933e32e664a12233213e6dce5c76a307a3f989"
    sha256 cellar: :any,                 big_sur:        "7adbfaa213d56b44eb98645794f954e298dda776f37d5106e40c563704f1a7ab"
    sha256 cellar: :any,                 catalina:       "b204c9a07dce5bf4f476c9912f177481a69e8843045ab19d01f3e016d875dceb"
    sha256 cellar: :any,                 mojave:         "de46ee6c3c638829ba3b9dc3ee009811d26a19359d10804b9ff93706df2a6863"
    sha256 cellar: :any,                 high_sierra:    "66b1b073b1ae7db629c64f66249254aefcb8fb6585c065c858a364bd258785d4"
    sha256 cellar: :any,                 sierra:         "3bd2c41c7f76e214c0964acec02723d2a2a611eca92cf5edb93c029333a78adf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19c0a42d20e64b6e6f769d958a02325f0c2a0fabc09c4c56d2a9c711e49cc2a1"
  end

  head do
    url "https://svn.code.sf.net/p/dosbox/code-0/dosbox/trunk"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libpng"
  depends_on "sdl"
  depends_on "sdl_net"
  depends_on "sdl_sound"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-sdltest
      --enable-core-inline
    ]

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/dosbox", "-version"
  end
end

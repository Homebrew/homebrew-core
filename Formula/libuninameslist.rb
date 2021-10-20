class Libuninameslist < Formula
  desc "Library of Unicode names and annotation data"
  homepage "https://github.com/fontforge/libuninameslist"
  url "https://github.com/fontforge/libuninameslist/releases/download/20210917/libuninameslist-dist-20210917.tar.gz"
  sha256 "43b0c5f10a15be3ee7215c7dc249286fcafbecd21d0d160944094ab106969a10"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)*)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "8581059a058192db3b35af24935a3558f0f56225a7a385f3a7cd9275c6befc5d"
    sha256 cellar: :any,                 big_sur:       "934119708939c95e650ac5b71d91d641271cd29d19531b01b10cffaeef5540b1"
    sha256 cellar: :any,                 catalina:      "bae124332a8758ab65c61230180c586c730b852d853c3fcf0705cd3e18a7e6ed"
    sha256 cellar: :any,                 mojave:        "be2893d87050b61ecfd82425a034873f8decb5d6d541ca604d0cc4f54dedd1dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c127ca07c9d350ba1fec668a8bce88ee221e5dd47350ea67218793297990c752"
  end

  head do
    url "https://github.com/fontforge/libuninameslist.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    if build.head?
      system "autoreconf", "-i"
      system "automake"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <uninameslist.h>

      int main() {
        (void)uniNamesList_blockCount();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-luninameslist", "-o", "test"
    system "./test"
  end
end

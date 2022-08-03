class Libbluray < Formula
  desc "Blu-Ray disc playback library for media players like VLC"
  homepage "https://www.videolan.org/developers/libbluray.html"
  url "https://download.videolan.org/videolan/libbluray/1.3.2/libbluray-1.3.2.tar.bz2"
  sha256 "456814db9f07c1eecdef7e840fcbb20976ef814df875428bfb81ecf45851f170"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.videolan.org/pub/videolan/libbluray/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ad906ee5fd5ef4913989acf3eec9a28fdaed7d1a64939e699f6490765522927a"
    sha256 cellar: :any,                 arm64_big_sur:  "8a83ed6cd9d2dac0beb72f756b27850843d9cac1120b431b4a5cf4328c83ec9e"
    sha256 cellar: :any,                 monterey:       "356b4b7982107b4945562a7ec635c23f70df5c9d7d639d9770413ff2b10354d2"
    sha256 cellar: :any,                 big_sur:        "c98f79dc9aabdb616de7a5ee1ea8a0bc893d23c0af71369b65b093d215bc1d3e"
    sha256 cellar: :any,                 catalina:       "432eaf039acf5b061fa49b290e136e510b78123af081d2d0ed68f3b834e7da1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdbbadffa598be6ad26e857531b15352a3fa1416926f4ff29cb0328eff5309af"
  end

  head do
    url "https://code.videolan.org/videolan/libbluray.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "freetype"

  uses_from_macos "libxml2"

  def install
    args = %W[--prefix=#{prefix} --disable-dependency-tracking --disable-silent-rules --disable-bdjava-jar]

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libbluray/bluray.h>
      int main(void) {
        BLURAY *bluray = bd_init();
        bd_close(bluray);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lbluray", "-o", "test"
    system "./test"
  end
end

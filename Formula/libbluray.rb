class Libbluray < Formula
  desc "Blu-Ray disc playback library for media players like VLC"
  homepage "https://www.videolan.org/developers/libbluray.html"
  url "https://download.videolan.org/videolan/libbluray/1.3.0/libbluray-1.3.0.tar.bz2"
  sha256 "e2dbaf99e84e0a9725f4985bcb85d41e52c2261cc651d8884b1b790b5ef016f9"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.videolan.org/pub/videolan/libbluray/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1c297068ee5ecb823067ef68a754b87a4b25cadd5bfc9c02233c188cbe46641c"
    sha256 cellar: :any,                 arm64_big_sur:  "fb78d5e9950654e6f5da0e1cec9543decf00f7b5c17d9dce898981badd065073"
    sha256 cellar: :any,                 monterey:       "9391e09b56309bd34b82255fd9a53cb25db731fe01add0839610c51d2f9ee970"
    sha256 cellar: :any,                 big_sur:        "c5bcd42c46908cfed9df378bf73b25a23482dbb6676bec1322fc902f51aad07c"
    sha256 cellar: :any,                 catalina:       "acfe4417abf3c5169e7271e81043fd4fb6d26bcd2ea96a266b820c33e8492ac6"
    sha256 cellar: :any,                 mojave:         "1321b4dba202cd31bd086cab15545128c8f00081378aa5e03598e54774f9a3e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99d67c7d44abccfda5de4ea53b8393f006b39f9fb55138eae6cb04da78f7a854"
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
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lbluray", "-o", "test"
    system "./test"
  end
end

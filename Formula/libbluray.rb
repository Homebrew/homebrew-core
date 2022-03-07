class Libbluray < Formula
  desc "Blu-Ray disc playback library for media players like VLC"
  homepage "https://www.videolan.org/developers/libbluray.html"
  url "https://download.videolan.org/videolan/libbluray/1.3.1/libbluray-1.3.1.tar.bz2"
  sha256 "c24b0f41c5b737bbb65c544fe63495637a771c10a519dfc802e769f112b43b75"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.videolan.org/pub/videolan/libbluray/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e680c8af00d95066d5ef7894bed7ce94061242ebf6e460184352828b0b312892"
    sha256 cellar: :any,                 arm64_big_sur:  "d9a4488093c31eadb48532b98fc81681fc8fe6682a75a4d75c8b0d609300b92a"
    sha256 cellar: :any,                 monterey:       "8f2c34dd07b155183309014a966a9218cb386af5f028681fb2ad5a06319a82f9"
    sha256 cellar: :any,                 big_sur:        "263d41816556be074b45f72fc3362c953c91c0b98aa61872c83ef1459d8bb611"
    sha256 cellar: :any,                 catalina:       "e9ca85381212db088482193f9fc598284af4a3ac4d300a7b102f6fd7c202bab4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "950457b5ef1e53c1bb2e59c32e5baf99d9288d56658f39eb7a21f01c71f40960"
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

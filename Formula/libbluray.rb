class Libbluray < Formula
  desc "Blu-Ray disc playback library for media players like VLC"
  homepage "https://www.videolan.org/developers/libbluray.html"
  url "https://download.videolan.org/videolan/libbluray/1.2.1/libbluray-1.2.1.tar.bz2"
  sha256 "5223e83f7988ea2cc860b5cadcaf9cf971087b0c80ca7b60cc17c8300cae36ec"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.videolan.org/pub/videolan/libbluray/"
    regex(%r{>([\d.]+)/<}i)
  end

  bottle do
    cellar :any
    rebuild 2
    sha256 "a6390593b5e2044ae683f2a8bb1c206c6eb705b570ffede50e478be63c07ff81" => :catalina
    sha256 "b59b3ea706de1a5a0c5bae9db673e7659428ccb2b35c2b28a71aa5b6c91e996d" => :mojave
    sha256 "957c062a77d5ad187c21388a41352e416b8b5be65696bd042fc422a547365a98" => :high_sierra
  end

  head do
    url "https://code.videolan.org/videolan/libbluray.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "ant" => :build
  depends_on "openjdk" => :build
  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "freetype"

  uses_from_macos "libxml2"

  def install
    # Build system doesn't detect Java version if this is set
    ENV.delete "_JAVA_OPTIONS"

    args = %W[--prefix=#{prefix} --disable-dependency-tracking --disable-silent-rules]

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

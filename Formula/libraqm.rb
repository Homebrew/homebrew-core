class Libraqm < Formula
  desc "Library for complex text layout"
  homepage "https://github.com/HOST-Oman/libraqm"
  url "https://github.com/HOST-Oman/libraqm/archive/v0.7.1.tar.gz"
  sha256 "3a80118fde37b8c07d35b0d40465e68190bdbd6e984ca6fe5c8192c521bb076d"
  license "MIT"

  bottle do
    cellar :any
    sha256 "433cfa09f493996f697e288318dddb9f887caaa505e89f54e6258efca30c31c5" => :big_sur
    sha256 "9f76c8377e47263458e8e09ed5e616687b25dc51821296dcefe386eb63f4eb05" => :arm64_big_sur
    sha256 "4c45ed51cac6ceb29ea7d7c6c7461b54b5e7f5ecc708e6fbba4396a26489c743" => :catalina
    sha256 "d104c74c838f567086230184854a18444c570437434a001adc6ada04ce9a68a9" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gtk-doc" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "harfbuzz"

  def install
    ENV["LIBTOOL"] = Formula["libtool"].bin
    ENV["PKG_CONFIG"] = Formula["pkg-config"].bin/"pkg-config"

    # for the docs
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--enable-gtk-doc"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <raqm.h>

      int main() {
        return 0;
      }
    EOS

    system ENV.cc, "test.c",
                   "-I#{include}",
                   "-I#{Formula["freetype"].include/"freetype2"}",
                   "-o", "test"
    system "./test"
  end
end

class Libraqm < Formula
  desc "Library for complex text layout"
  homepage "https://github.com/HOST-Oman/libraqm"
  url "https://github.com/HOST-Oman/libraqm/archive//v0.7.0.tar.gz"
  sha256 "21ed67b8d0d2217f3801878f2ceef9b2da24495eeff830552051cef21f95938e"

  bottle do
    cellar :any
    sha256 "61857a8c4e5ffada95438c4b98d042c129ebf485b5141fc8cc1bbbb13052d2fc" => :catalina
    sha256 "b46d537983abc24546765d3d37f7a77330f82371a2c8899ada29e96324fee760" => :mojave
    sha256 "5599586ba85c892e36cfb5da6eb0bae54d8632b0c569bdcaa71b38b3ecab947f" => :high_sierra
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

    ENV["HARFBUZZ_CFLAGS"] = "-I#{Formula["harfbuzz"].include/"harfbuzz"}"
    ENV["HARFBUZZ_LIBS"] = Formula["harfbuzz"].lib

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

class Libraqm < Formula
  desc "Library for complex text layout"
  homepage "https://github.com/HOST-Oman/libraqm"
  url "https://github.com/HOST-Oman/libraqm/archive//v0.7.0.tar.gz"
  sha256 "21ed67b8d0d2217f3801878f2ceef9b2da24495eeff830552051cef21f95938e"
  license "MIT"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c216caedf4a6709818f70525be9c1bbea6872d35b5ddd7e967de5e06fa48d626" => :catalina
    sha256 "637d5a3258bb8928c537479687e82234ab0729650b23e00bcf5215fd3b6377b3" => :mojave
    sha256 "a7bf34866571bbcb37fc95c13d985c18494625bb34d08325aa9970c22a330e91" => :high_sierra
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

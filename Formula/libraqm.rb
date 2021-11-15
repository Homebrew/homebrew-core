class Libraqm < Formula
  desc "Library for complex text layout"
  homepage "https://github.com/HOST-Oman/libraqm"
  url "https://github.com/HOST-Oman/libraqm/archive/v0.7.2.tar.gz"
  sha256 "eeccbb0bf23ef77d8ff2be24a9c6c1547cc8e443d3d6b57814d73d44758d95c2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "31633bafe07acbb111d61d6903d1d31fdfa1442017083a656f45cec235b126a2"
    sha256 cellar: :any,                 arm64_big_sur:  "05c31c92e29b7202d42cb892a327ed2c5ca4e7f211020dcf4b54d1d08937479a"
    sha256 cellar: :any,                 monterey:       "472153565affc24e276667fb48629d8dabd9908ca23f45e5835889d096a39dac"
    sha256 cellar: :any,                 big_sur:        "66f14af1e2afb8aa3f89cb6b2bc0e0274a260bf832250364ec691e398296fe8b"
    sha256 cellar: :any,                 catalina:       "d619aee4f8e198220d88df6c68ab19ad4b4dbb1a16a4c910ffe923281461d4a5"
    sha256 cellar: :any,                 mojave:         "cd4063f2520edce76e7a53a676508410ba42bdfe34f3a49c58414f94ea2ab647"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9435ed91d1d18865b406874aedd92b2b7c34e211970d19aaccf550b20a68303a"
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

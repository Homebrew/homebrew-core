class Libraqm < Formula
  desc "Library for complex text layout"
  homepage "https://github.com/HOST-Oman/libraqm"
  url "https://github.com/HOST-Oman/libraqm/archive/v0.8.0.tar.gz"
  sha256 "6429e35f69f5e7d514877624fb73ae6d07a7e9ac746ae6a1cf2bf1277bb5b68d"
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

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "harfbuzz"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
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

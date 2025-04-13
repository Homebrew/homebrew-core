class Libraqm < Formula
  desc "Library for complex text layout"
  homepage "https://github.com/HOST-Oman/libraqm"
  url "https://github.com/HOST-Oman/libraqm/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "db68fd9f034fc40ece103e511ffdf941d69f5e935c48ded8a31590468e42ba72"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "2dcf80407a7a45257a5d099ce9b9e041315cfa40172b63ef04f0f279f5df14cb"
    sha256 cellar: :any, arm64_sonoma:  "7dbd6b420b6f06c4c9627955e8aec47f75655a9b3557c83b2123edc94d4ddbaa"
    sha256 cellar: :any, arm64_ventura: "2cb4fae2a63f43d2fffba40060492d6a0c577198c32dd878277953e9097341f4"
    sha256 cellar: :any, sonoma:        "5cca7d3c4e68f13d5d94fe0e775578d7e75d5baecba6914ea7c8953aa48d4cd3"
    sha256 cellar: :any, ventura:       "5a04efc31fb102abee7e294ff201304375b8fab445c0f097b5dded104a3462c3"
    sha256               arm64_linux:   "9b761532205d53cf4a302ca211d4246a566019bc4bf9715ef51e3b32006f70e2"
    sha256               x86_64_linux:  "9676804e1ac66a629bdbc1016d76f42a7a989e42bdcad1de59e86912e9c86f54"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "harfbuzz"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <raqm.h>

      int main() {
        return 0;
      }
    C

    system ENV.cc, "test.c",
                   "-I#{include}",
                   "-I#{Formula["freetype"].include/"freetype2"}",
                   "-o", "test"
    system "./test"
  end
end

class Libraqm < Formula
  desc "Library for complex text layout"
  homepage "https://github.com/HOST-Oman/libraqm"
  url "https://github.com/HOST-Oman/libraqm/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "ff8f0604dc38671b57fc9ca5c15f3613e063d2f988ff14aa4de60981cb714134"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "9b5a391bb26536281881edbf59e39ab0fe746ee19551d931c8b4c0168ce1033c"
    sha256 cellar: :any, arm64_ventura:  "ac95b8239c3e26dfd2cba18417d279cf5fe39cf1e3b02e01930e324fa4334174"
    sha256 cellar: :any, arm64_monterey: "d9099efce8323f9b653b9277a98a392aea1cb850ca69988aa17616cd44fc5741"
    sha256 cellar: :any, arm64_big_sur:  "1df9106df6fbcc29f5ec9dd66790a04c9d34480a42b4c43ae868ff72a3e312ed"
    sha256 cellar: :any, sonoma:         "860fe5236ee6417c25794bbe427b77815b585920c9f1ef9173342ca692311cbb"
    sha256 cellar: :any, ventura:        "0f1d8cb37227f292b974a59b065a0c5d52869a85a5aa8f2dcd3c1466a32030e7"
    sha256 cellar: :any, monterey:       "2e263d71e11d6e370a8e162d4abd2b086bbecb522d26935f8045dc3943cb85d4"
    sha256 cellar: :any, big_sur:        "8726ac6422de7578e09239f921548c394c0c5005d8b3a2931d4d202187fe9281"
    sha256               x86_64_linux:   "daf4d9a748329b05386ae982acb20fc88f1b1eac39d10d8f657527f255438165"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "harfbuzz"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
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

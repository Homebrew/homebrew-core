class Cgif < Formula
  desc "GIF encoder written in C"
  homepage "https://github.com/dloebl/cgif"
  url "https://github.com/dloebl/cgif/archive/refs/tags/V0.2.0.tar.gz"
  sha256 "d00fd4bf2a7b47bc3b0c3b2c8f2215b1bdfd88f0569388d752909b878db27bfb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "179a4f69a4e8877dd17a18483e56f7ff9fa0c7999983eba4ddfcecdc5b45ded4"
    sha256 cellar: :any,                 arm64_big_sur:  "1cca71fb27aae3e6dbb0077646c2d0baf13f892713dc99b5ead755863a826daf"
    sha256 cellar: :any,                 monterey:       "da19f5c2ec72ded85131e8d29e7880d548246bae3e3a59c5bb0954d9eb639f98"
    sha256 cellar: :any,                 big_sur:        "b26e87b4f8c4a82c77701c1c8c15657d5d7b0b1595f08a96241a3853a239c012"
    sha256 cellar: :any,                 catalina:       "240e734b94eb80733203a873f937b0b395f338936924f809f4075b9ccc38f44f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0344481b59132128d60b819a4ac5b107010702b402eaa7addbd888b49f7f568a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "..", "-Dtests=false"
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"try.c").write <<~EOS
      #include <cgif.h>
      int main() {
        CGIF_Config config = {0};
        CGIF *cgif;

        cgif = cgif_newgif(&config);

        return 0;
      }
    EOS
    system ENV.cc, "try.c", "-L#{lib}", "-lcgif", "-o", "try"
    system "./try"
  end
end

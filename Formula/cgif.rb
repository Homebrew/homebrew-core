class Cgif < Formula
  desc "GIF encoder written in C"
  homepage "https://github.com/dloebl/cgif"
  url "https://github.com/dloebl/cgif/archive/refs/tags/V0.3.1.tar.gz"
  sha256 "74a56ddd07b0a28938918f9d566012d4324fd183d3783a075f656520e79d82fb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0988cc00c20a6cf83021e8f06fb8c2f075ef87107f07b29906dfcc45ca40c17e"
    sha256 cellar: :any,                 arm64_monterey: "a2b754f882aa2a2540d1bba387ac07c02e5e0e7c7a097490af3f3db7494228d2"
    sha256 cellar: :any,                 arm64_big_sur:  "89458e228d8532e93a88dcad85b8dba5c4d64143be4a0a6d33e9ded1b02bb712"
    sha256 cellar: :any,                 ventura:        "e32bb231e04b725cfd0ea857e7a2a783de26fd3ba62c75da59dadb391d5eb0fc"
    sha256 cellar: :any,                 monterey:       "50b1cbf79278e276f4c6b7d3a2618584e6ce73894b09ab256c4a322056aeefd6"
    sha256 cellar: :any,                 big_sur:        "2c4297e13eaf55ac3f4d76800f1f264a2bbf4c466a318c9dbafc344b0efb1f81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0bb225118b9a12955e97d401af3e86d95f89b7082f8ed6f42e289eb92e6fbe4"
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

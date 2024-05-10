class Cgif < Formula
  desc "GIF encoder written in C"
  homepage "https://github.com/dloebl/cgif"
  url "https://github.com/dloebl/cgif/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "130ff8a604f047449e81ddddf818bd0e03826b5f468e989b02726b16b7d4742e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c96d2d676dbb4dc1b53d9fae0ffe0089d781a958dba380f82f644f271107dd82"
    sha256 cellar: :any,                 arm64_ventura:  "f458f793e4fc65b7b6eaeb4aa8f5f41e506fac67a444c97080e279793314c3f8"
    sha256 cellar: :any,                 arm64_monterey: "d70c81e0bccf84c061ccab8789ad5aaa49d10fd10aaeab420c030ec8b17fb5a1"
    sha256 cellar: :any,                 sonoma:         "b90e5c1790452de1deb4993af325cd43f764d2b3dd0438369ec7d82477a167c5"
    sha256 cellar: :any,                 ventura:        "5c634594c356c27c8694f009f16d413533606803b96e939d2f8f2e1308887dbe"
    sha256 cellar: :any,                 monterey:       "3dc7039ee850779befe7a93a3c2d25c9af7b93c5f6b40e73fd494eca615b5262"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3241b917f35a85f835b5ad08778ed761bf7915dd4b14664fd4ef55ed7d17089"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
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

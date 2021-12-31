class Cgif < Formula
  desc "GIF encoder written in C"
  homepage "https://github.com/dloebl/cgif"
  url "https://github.com/dloebl/cgif/archive/refs/tags/V0.1.0.tar.gz"
  sha256 "fc7a79d79c7325cd3ef2093fece064e688bbc0bc309c1a5feae3e62446bbd088"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7c4d36424bf2c7ff17de89d20d8ceebc4e3616c8fa76471abd0fa3f7546acfb6"
    sha256 cellar: :any,                 arm64_big_sur:  "81c9ce010ff49cbfa918190a6bc2205e2f821e8993dc0cd3d4905d63967a1ccd"
    sha256 cellar: :any,                 monterey:       "67b5521c594b3645676ec7705c2a8179d29f059bb03e5fe890cdd9b7992418d8"
    sha256 cellar: :any,                 big_sur:        "2747e835b396f2f6827cd66ae47fde3ab1c44764b009fab07caa2f01b6307ec9"
    sha256 cellar: :any,                 catalina:       "343dc11b8d3162ee847f90ec24b722e4d36dfdbce6ef18b7702f9ffa4d81cb64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5418bee8358ee6a8b882a694626af986113f98bd044b902e6b417f897e828c6c"
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

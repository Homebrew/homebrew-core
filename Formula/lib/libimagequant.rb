class Libimagequant < Formula
  desc "Palette quantization library extracted from pnquant2"
  homepage "https://pngquant.org/lib/"
  url "https://github.com/ImageOptim/libimagequant/archive/refs/tags/4.3.4.tar.gz"
  sha256 "b86f4ac0eb707af88b0a000e2e2409e399c6969c9d0d988efafaff138cebaf96"
  license all_of: ["GPL-3.0-or-later", "HPND"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9bd28748f04704e33c3d4742967af6b35ad9cb13012affff2ceda5acf65dbc9c"
    sha256 cellar: :any,                 arm64_sonoma:  "af5fc3992c73074f93497b564f031620340830cb9a852da315d30d18c49e8607"
    sha256 cellar: :any,                 arm64_ventura: "fd25336fb8baca27c2f54acb62b3e4b25a6faf9af29fe7d78628955329b158f6"
    sha256 cellar: :any,                 sonoma:        "f2f6742ba54280cff5c687780ae26cb32694ce7934c65e639e1b4929b76a8b8c"
    sha256 cellar: :any,                 ventura:       "e96abab1e43ccedaeb0fc887b8ebfa8b7481d3c734578689bb1b00e76a394cb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8aec6a023e0a5e6b7aa3683661b2067c8469236acc5770ece554e8b8c0248f08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88ff1ab2e4d2b4837b96df12d676432af7d8d03185e4152549c5332c6e657ed3"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build

  def install
    cd "imagequant-sys" do
      system "cargo", "cinstall", "--jobs", ENV.make_jobs.to_s, "--release", "--prefix", prefix, "--libdir", lib
    end
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libimagequant.h>

      int main()
      {
        liq_attr *attr = liq_attr_create();
        if (!attr) {
          return 1;
        } else {
          liq_attr_destroy(attr);
          return 0;
        }
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-limagequant", "-o", "test"
    system "./test"
  end
end

class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/refs/tags/v1.33.0.tar.gz"
  sha256 "c9018fbd69b825cfc706d8c40e9464be37e924ce07089933e92f4f931ccf0d8d"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dcb16a5854d7d8c2ab4542cc14379a6de38fd98f19e710d657d78c000f42ee60"
    sha256 cellar: :any,                 arm64_ventura:  "d4452310aee90f3394ddf6e8906932f477dd1f1aa33078a488d499eb577cd6ee"
    sha256 cellar: :any,                 arm64_monterey: "49bc77272a00654a8483a182924522a3c1168545e2f3933e4f9ac3ec7e0d6573"
    sha256 cellar: :any,                 sonoma:         "e27fba1601ed6bb35a2ff0bc1a6fd9ef33e91022dcd75315c37097583e042f0e"
    sha256 cellar: :any,                 ventura:        "02e3a2d4a1ddd56434a909ab5e41995c41873f3dc01b6f9e94fb434de176b93a"
    sha256 cellar: :any,                 monterey:       "85bd8239728727e99189f310667951e289a16ed7c29de1124c76bdc0d46ab066"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb578b406d3a2dcfae195d5969efe579ad3f6a3bd6fa73b5f658eaca0adf3d71"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  resource "jpm" do
    url "https://github.com/janet-lang/jpm/archive/refs/tags/v1.1.0.tar.gz"
    sha256 "337c40d9b8c087b920202287b375c2962447218e8e127ce3a5a12e6e47ac6f16"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    cd "build" do
      system "ninja"
      system "ninja", "install"
    end
    ENV["PREFIX"] = prefix
    resource("jpm").stage do
      system bin/"janet", "bootstrap.janet"
    end
  end

  test do
    assert_equal "12", shell_output("#{bin}/janet -e '(print (+ 5 7))'").strip
    assert_predicate HOMEBREW_PREFIX/"bin/jpm", :exist?, "jpm must exist"
    assert_predicate HOMEBREW_PREFIX/"bin/jpm", :executable?, "jpm must be executable"
    assert_match prefix.to_s, shell_output("#{bin}/jpm show-paths")
  end
end

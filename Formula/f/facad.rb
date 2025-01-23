class Facad < Formula
  desc "Modern, colorful directory listing tool for the command-line"
  homepage "https://github.com/yellow-footed-honeyguide/facad"
  url "https://github.com/yellow-footed-honeyguide/facad/archive/refs/tags/v2.18.0.tar.gz"
  sha256 "2c4b487fce0046767e37fbbfe77e530b38d4184a5a82710c9fdd74d184b71f0a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c254eed36076c6b8d245084f8a81728d821eaac846c0b51a9e464062181efe27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52e69e6903590f5b7a7908b0c31a714a841ecf57905a93cc26dd8e4ad7790308"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d67892e3de277927b006478e9beae4039db3e02f7c4ca599a06bb9ec9078721f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d109477775cc9e45648c9713d16452dbb3453449a3b52ad6a085f116cf2393c1"
    sha256 cellar: :any_skip_relocation, ventura:       "f358dd6f18d143fc6af661391998eaad63d3d11a54e7d89aba4cbc328049667b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62058b41a686d0bf5aa4e55b0efb2dadd14778b52a9591991b1fe69bd60d9adb"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "facad version #{version}", shell_output("#{bin}/facad --version")

    Dir.mkdir("foobar")
    assert_match "📁 foobar", shell_output(bin/"facad")
  end
end

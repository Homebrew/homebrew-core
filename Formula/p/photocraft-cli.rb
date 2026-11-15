class PhotocraftCli < Formula
  desc "Headless PhotoCraft engine to convert, inspect and batch-edit images"
  homepage "https://getartcraft.com/apps/photocraft"
  url "https://github.com/storytold/photocraft/archive/refs/tags/v0.23.1.tar.gz"
  sha256 "66786e5b1e88bff0a1f04ab5073be50faa7e65b3cdebcbd679e1837ff52a82c6"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/photocraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "336ce07304dbd2d0aaa476f4874b546e210b3ac8390035544c403f0c30400f5d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "baa0925451b02065313f5b74adc4bf9bf1cf09837062dff070df5fc37589e69d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "63772af98b484543c7272d2f7713b4cb9556e1dc76b775dde2df19445746e11d"
    sha256 cellar: :any,                 arm64_linux:       "b4d4f4115a10f1f3278e0a3cffe9c9aa89104db02ef992f688e6b7b5dea87d27"
    sha256 cellar: :any,                 x86_64_linux:      "39556b6289875cee0447b82ea04824ccf3892d42992a3fb28fded71f9b41cdd6"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/photocraft-cli", features: "heif")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/photocraft-cli --version")

    system bin/"photocraft-cli", "run", "--new", '{"width":16,"height":12}',
           "--cmd", "layer.new.layer", "--out", "test.pcraft"
    info = JSON.parse(shell_output("#{bin}/photocraft-cli info test.pcraft --compact"))
    assert_equal [16, 12], [info["width"], info["height"]]
    assert_equal ["Layer 1", "Background"], info["layers"].map { |layer| layer["name"] }

    system bin/"photocraft-cli", "convert", "test.pcraft", "test.png"
    assert_equal "\x89PNG".b, (testpath/"test.png").binread(4)
  end
end

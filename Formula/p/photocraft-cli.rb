class PhotocraftCli < Formula
  desc "Headless PhotoCraft engine to convert, inspect and batch-edit images"
  homepage "https://getartcraft.com/apps/photocraft"
  url "https://github.com/storytold/photocraft/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "99057c93f2834db988623b8e4366c99e3b7ae2c52b08dadc1260b02ec29d32b4"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/photocraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "99bc9ed88d5507e64db619b88d7e315476bf0245117fb922229ccc2cd8250055"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0810e95cefd7b19d216ac331e74d473170191fd24198b5b7d6e35f7c8a681e95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d30f4f607ca90128cd8f68337aa085e3e761d93e00e3c9b9c53c917a4091fc55"
    sha256 cellar: :any,                 arm64_linux:       "7d44b42bef426806f6fc56b997fd475685a5551a17aa04a5cffdad0903098320"
    sha256 cellar: :any,                 x86_64_linux:      "5f973389fc140c5482602c28686fe467ba87979234789554b200f9994c2e606e"
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

class PhotocraftCli < Formula
  desc "Headless PhotoCraft engine to convert, inspect and batch-edit images"
  homepage "https://getartcraft.com/apps/photocraft"
  url "https://github.com/storytold/photocraft/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "0cc46664dfdc9c7061c7b3342476854a35610f13ebf2c54983690f42e105154e"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/photocraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "55cd9e309e29439a69b5853972ce2153edb90b01a68420eb2e5dd09124526d0e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "596d5d954b6d66b2d312396fee54970470fceffb723e77e20ca11bb7ad8f8c60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ad04782d33d40bdbfd596f1990b251cfced2aa5b999b24519802011872dcdc5e"
    sha256 cellar: :any,                 arm64_linux:       "d0e134d74c281997526174e52b9a1e97ce63a31da09b44d5cb1188e20dd703cf"
    sha256 cellar: :any,                 x86_64_linux:      "d9b4f23828cd8310ef7f6643af632c8f53757e8abc5b9c9547bc34420e415fa0"
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

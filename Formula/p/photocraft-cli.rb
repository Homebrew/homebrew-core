class PhotocraftCli < Formula
  desc "Headless PhotoCraft engine to convert, inspect and batch-edit images"
  homepage "https://getartcraft.com/apps/photocraft"
  url "https://github.com/storytold/photocraft/archive/refs/tags/v0.20.2.tar.gz"
  sha256 "1712c29da436d08899797d95f1558c629c0b8210836960b8f114623cfc5da08a"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/photocraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "51b1965c0babcb8cf0202e82f046f43463f7823a771397b9854a43a12c92ce5d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d05ee6145e2d03ee040262950ba2699b8926f6f1c226acdea4bc6aed69deba2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f43b5ebcb9a92658594d8a59bfbc04b829618598d49646a0627a0339c7fa775f"
    sha256 cellar: :any,                 arm64_linux:       "adf20b6957031c7a64f74e30196d1701eaf1b0a1d534f6e40cd8caa3f9c4c4ba"
    sha256 cellar: :any,                 x86_64_linux:      "c6e14e1788dca14eb2ad3b3a3926353e252b40535209830c2c59c39fb44c9597"
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

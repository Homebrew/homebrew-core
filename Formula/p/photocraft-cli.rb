class PhotocraftCli < Formula
  desc "Headless PhotoCraft engine to convert, inspect and batch-edit images"
  homepage "https://getartcraft.com/apps/photocraft"
  url "https://github.com/storytold/photocraft/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "6632913f47e6ddace490c63311b3d26c7cdad941c46deaa74ac3e7764d758810"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/photocraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fbed5e604d4bc77e7cdd69fc2ce96223ea07547647916a485b78b9413e43564e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c5f1d059c22ef63371cc35b36a5466af1c1f7a4192849cbd10d747664ab2ae9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3cdcd1ecde70903ebbd8abbcbdee0cc5e0e3b98f8c82efa779f414834fc71637"
    sha256 cellar: :any,                 arm64_linux:       "ec659f2e409623b086f14683073bd02a10521b9ae64af598eb0dc7c9e285fcf1"
    sha256 cellar: :any,                 x86_64_linux:      "8b1d83d3c8c2ad2cf3d8fea3dd41fae51295914ea24e6edca9dad837a66be93a"
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

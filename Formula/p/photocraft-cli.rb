class PhotocraftCli < Formula
  desc "Headless PhotoCraft engine to convert, inspect and batch-edit images"
  homepage "https://getartcraft.com/apps/photocraft"
  url "https://github.com/storytold/photocraft/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "33148777097149ec45da662bf8c38e18c70e67e12fef4fcb4739ea73ef521552"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/photocraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "742d8d6c198a802b2f9f2e785b7139b4768250ceef8b8539f6622297524be5b0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7703de545576c8e42001686525c38617885f49bb78fa5a00347fbafd490961ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4825e9e0e9382f0a925acc32b9fc29b13f7ca24a1a3a5230aa6ff8f55c4528e6"
    sha256 cellar: :any,                 arm64_linux:       "e1f1cb683277d5397ad0f7671cf4bbf2437238b8947c5719c81505e184f2e9a5"
    sha256 cellar: :any,                 x86_64_linux:      "f8705d7dcc909879d631df220f9284165dbe77562b893ce4d97aefd6dc01c29b"
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

class PhotocraftCli < Formula
  desc "Headless PhotoCraft engine to convert, inspect and batch-edit images"
  homepage "https://getartcraft.com/apps/photocraft"
  url "https://github.com/storytold/photocraft/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "0cc46664dfdc9c7061c7b3342476854a35610f13ebf2c54983690f42e105154e"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/photocraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a61ae5e3e3e09f7b6ace6ad6fa3717625d39c7c21b31f0922ed08ca57ae7152c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "160d1f637c7091399829ba94dd5a56ef25050accec869f74ce416e3ff2b15adb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6d83565e8916e441044b959d3f23b87b2b9a5ab6a950b9e21cc15bb4015b92dc"
    sha256 cellar: :any,                 arm64_linux:       "3a43ca4d664872ad1b09cbca1b4738008f46c89cebfb0c653b0fe9e055c6fb56"
    sha256 cellar: :any,                 x86_64_linux:      "ae75467ee1d37cbd7623e1ec6c260651643e236e487b344eb87b831495c97ee2"
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

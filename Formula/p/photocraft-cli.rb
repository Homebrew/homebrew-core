class PhotocraftCli < Formula
  desc "Headless PhotoCraft engine to convert, inspect and batch-edit images"
  homepage "https://getartcraft.com/apps/photocraft"
  url "https://github.com/storytold/photocraft/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "5c9ee3e85cb3d12ee12866a001728aa619d07a8cc2fd8b3f08280334f7381d16"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/photocraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0520427f7688917ac8c395adf92bbe19e45e73f983409e3d371e47eed756a298"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "caaf41f6e5c8af5a6ca0aad60b4aea8cd914e223638e69705308603ead926b92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ff4f37150730df36a8517dcb4c66f840e19ea0479ce7196e36c0f7407810189d"
    sha256 cellar: :any,                 arm64_linux:       "ee9707b874b3c2ec144af5a1fc8d4c3d2f651d89c38fc81f694a3fc2772080ab"
    sha256 cellar: :any,                 x86_64_linux:      "3deabb34db0fbe9e7a819d50f08ad387620b4dbf52db6c6c9d72c83cd1a78bc8"
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

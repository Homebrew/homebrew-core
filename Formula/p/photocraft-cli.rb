class PhotocraftCli < Formula
  desc "Headless PhotoCraft engine to convert, inspect and batch-edit images"
  homepage "https://getartcraft.com/apps/photocraft"
  url "https://github.com/storytold/photocraft/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "4f9f9e165d1f37fefa7ed13a8a36c77c783f692e912100cdab275a5ff7d2e632"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/photocraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a4cafbaf41a99f42d101a76ef322d4dd507120359ba1b2d67888f8f5b39080de"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "32fdff964195796f3f1b8cf0bcff1a54f3324b9302fe0ed09c5b0a3e7e4b8cf3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b7f53a95601017259b9257883a9259e7430185872c896e8cea5d00ad23ebee3e"
    sha256 cellar: :any,                 arm64_linux:       "aed661d374a1450ebb4fa1273cae8af5c67198022cca2386377ccbf68bec9076"
    sha256 cellar: :any,                 x86_64_linux:      "c6b67ec2494407b16bf72060b9cd497f1318a331db690aa212f0a8c04a26ee30"
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

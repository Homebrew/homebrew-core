class DrawThingsCli < Formula
  desc "Local inference and LoRA training CLI for Draw Things"
  homepage "https://github.com/drawthingsai/draw-things-community"
  url "https://github.com/drawthingsai/draw-things-community/archive/refs/tags/v1.20260430.0.tar.gz"
  sha256 "c8b8fd0f1de3d8e4b05bbc2f0f19cc507b871f86eefa6b2da26b4aca9357f9cc"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aeb7badeb9d010a44b2ce63f57de1273b63eb61a18c6a006ac4b068c7a1d3c0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "227c080b0ab4ea488ceee58b5c0f195f6c054947818cff2f86bde1e7bf188dee"
  end

  depends_on xcode: ["26.3", :build]
  depends_on macos: :ventura # needs CoreML and other Apple frameworks

  uses_from_macos "swift" => :build

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "draw-things-cli"
    bin.install ".build/release/draw-things-cli"

    generate_completions_from_executable(bin/"draw-things-cli", "completion")
  end

  test do
    # Point --models-dir into testpath: the default location is outside the
    # test sandbox and depends on host state (Draw Things app container)
    models_dir = testpath/"Models"

    list = shell_output("#{bin}/draw-things-cli models list --downloaded-only --offline --models-dir #{models_dir}")
    assert_match "No models found.", list

    generate = shell_output(
      "#{bin}/draw-things-cli generate --models-dir #{models_dir} --model test --output . --prompt 'test' 2>&1", 64
    )
    assert_match "Error: Could not resolve --model 'test'.", generate
  end
end

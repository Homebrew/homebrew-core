class DrawThingsCli < Formula
  desc "Local inference and LoRA training CLI for Draw Things"
  homepage "https://github.com/drawthingsai/draw-things-community"
  url "https://github.com/drawthingsai/draw-things-community/archive/refs/tags/v26.1014.0.tar.gz"
  sha256 "5d53f33c8662ce5e1a0e8ffb131d921b565a8010057e2c450bd101f2e9292fb9"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "235f6741d450d39c2ba562149c25189085018720f4fe696d599fc9089b94f6fe"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7044e4094833edca8252b76d5267144d152eef55d5c475d96fc69ad2b508ab3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7222cdf1325cd06d1aebe139b76bce0deb6925c9213ce249b7fad5654c4bd693"
  end

  depends_on xcode: ["26.3", :build]
  depends_on macos: :sequoia # aligned to build Xcode as cannot cross-compile

  uses_from_macos "swift" => :build

  def install
    system "swift", "build", "--product", "draw-things-cli", *std_swift_args
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

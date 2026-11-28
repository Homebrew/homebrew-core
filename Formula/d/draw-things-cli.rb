class DrawThingsCli < Formula
  desc "Local inference and LoRA training CLI for Draw Things"
  homepage "https://github.com/drawthingsai/draw-things-community"
  url "https://github.com/drawthingsai/draw-things-community/archive/refs/tags/v26.1118.0.tar.gz"
  sha256 "8f6b973607731aaf5c1d8c158cad62fd5785a8ed487b55fb8ae6569f6c523f18"
  license "GPL-3.0-or-later"

  bottle do
    manifest_sha256 "7475629549e1c786f631e131a0d58fc39ba4e734e0351df0f7d95233f450ba0c"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "49f9668ff1058453b6e6195f0fe120058a9adc0be36b4010f934fadc13859440"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "642a6652bcb502c4dec0ba7b6a5a7343e41c1e344fd8a7d9a3a1e8229ce43db7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7101b8ba38e7a9b392f2c3589c8d123ebeafd2886ba91aa1ce1df60c0e249956"
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

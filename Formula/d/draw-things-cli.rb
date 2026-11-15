class DrawThingsCli < Formula
  desc "Local inference and LoRA training CLI for Draw Things"
  homepage "https://github.com/drawthingsai/draw-things-community"
  url "https://github.com/drawthingsai/draw-things-community/archive/refs/tags/v26.1023.0.tar.gz"
  sha256 "6d1a04ce4f3669847477a4cd0f46fed4d42cd9f593235a0ad8b20ee5c40cbfee"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "52e556568bea7821f9825bbefade3e70bde6dee34bd7621b737993b95705de2e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7487d81097d9f43401014ef77837e3879553985b3f7e3f199ac8dbf03bdfe282"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "79411743351a2291f17b56697aadbdb07e09f20c7f4a441f87a15c2f658be9b6"
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

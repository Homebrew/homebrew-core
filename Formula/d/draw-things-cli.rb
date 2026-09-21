class DrawThingsCli < Formula
  desc "Local inference and LoRA training CLI for Draw Things"
  homepage "https://github.com/drawthingsai/draw-things-community"
  url "https://github.com/drawthingsai/draw-things-community/archive/refs/tags/v26.0910.1.tar.gz"
  sha256 "c5c91c0641b1efd12079e8151751e0a1b299d6374b4fa803abea80e695787eee"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ee89eb28bd2fb5360397b03852aa47af8e388af293850dda19f1c3431af126e8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "75859cc0b38ccd9fbbc7bd6e8db7f423e9320aa134487ef0cceba0b492722d5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "85ab83ab23c85bd6c2d1121c55b3c83a5035cd51de7089f6c4806f2832bd5bc9"
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

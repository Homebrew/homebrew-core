class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.19.1.tar.gz"
  sha256 "9053d36a8244aace44c198e90eab5d7d6701b7d5697e0d715b559e053604b9af"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "30338c574c9df0ea42d804b753626fcdbf478316def75a70f8cc6a7a517accd9"
    sha256 cellar: :any, arm64_tahoe:       "83c2345360fe4bb71f04dc1a0bfbe7f95915bc6032b520cc62a9534e4a2a33a8"
    sha256 cellar: :any, arm64_sequoia:     "386c6cae946d27750d65211b4d74e91f308519627e82a7cabb59806a8a7ef557"
    sha256 cellar: :any, arm64_linux:       "6f2c0a8789be774f9f6b599a3f4f5dbef7390d02a6063b130da9fcde640ca9bf"
    sha256 cellar: :any, x86_64_linux:      "e9eac5e0167c78c9c9325c6f49ea85781938e9a1c1f45edb8113fa53a5a17977"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "portaudio"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args(tags: "portaudio_system", output: bin/"lk"), "./cmd/lk"

    bin.install_symlink "lk" => "livekit-cli"

    bash_completion.install "autocomplete/bash_autocomplete" => "lk"
    zsh_completion.install "autocomplete/zsh_autocomplete" => "_lk"
    generate_completions_from_executable(bin/"lk", "generate-fish-completion",
                                         shell_parameter_format: :none, shells: [:fish])
  end

  test do
    output = shell_output("#{bin}/lk token create --list --api-key key --api-secret secret 2>&1")
    assert_match "valid for (mins): 5", output
    assert_match "lk version #{version}", shell_output("#{bin}/lk --version")
  end
end

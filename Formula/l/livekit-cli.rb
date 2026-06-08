class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.16.4.tar.gz"
  sha256 "064070e62e3cd864c2e02f999eb6e000ce9ba5ecf7f7cbeffc2cf8d9685ffa7e"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b25fec81fad7aa299d8fbaf5fd8a11303c4056a1d8fe50b9c657f16e4a0d90c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0dfde6c510b3afa4edcfb524c1b6abf6cebccd12a468015b93fa2e5a081b0965"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2f5d630d9a1ee6d8cb3a4c77e1f3c4f0a5c825e511f6d07c973cbec4afcd62b"
    sha256 cellar: :any_skip_relocation, sonoma:        "505a80c580f10a255a066405fec80a60a8004eb6450a98b3d9e8cb435511c9d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4c5840ab902cbcbf7de9ce18768a5d68eaae9e1f87b0ca2d6e56b358ba7c9d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "516a94f44404a990e277d914478f83d6e3d732c72a6ff2bbdc4b40e08ee3de08"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:, output: bin/"lk"), "./cmd/lk"

    bin.install_symlink "lk" => "livekit-cli"

    bash_completion.install "autocomplete/bash_autocomplete" => "lk"
    fish_completion.install "autocomplete/fish_autocomplete" => "lk.fish"
    zsh_completion.install "autocomplete/zsh_autocomplete" => "_lk"
  end

  test do
    output = shell_output("#{bin}/lk token create --list --api-key key --api-secret secret 2>&1")
    assert_match "valid for (mins): 5", output
    assert_match "lk version #{version}", shell_output("#{bin}/lk --version")
  end
end

class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "a79d8d75efccd20f7e614d84ce736210f130abcabe5aa2f1b09b395d23193ff4"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e728e514e28d57363550df645f1f26cc8f657d0945d3c0ec561cb02ae302dfe5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2418dcce55bb1b9891465f38fb1fff6a5fd90cfe9b15fbb1e262abed25c7d463"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64b9348954fe50a5314386e4179bd1c70c55587f6a1a10f8931cc107b34d7e8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "850008a35ced52d8cf6894e699cfc455a484f66ff74556cc3a6eef1ac20a6df6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f744ffaa1e36181ec4cfde084d7f5157c1efb2989ffb7778cab4a91ddf7a32de"
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
    output = shell_output("#{bin}/lk token create --list --api-key key --api-secret secret")
    assert_match "valid for (mins):  5", output
    assert_match "lk version #{version}", shell_output("#{bin}/lk --version")
  end
end

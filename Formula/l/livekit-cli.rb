class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.5.6.tar.gz"
  sha256 "beea580f7ac7aa56bf4ae6c648437ee2fbb370588154f2902c450e9dece97607"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "869014d8cea1644d6c499ea0b3150af01d2c68c13dbfbb0dac111834e5d5eb9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb4b6477fb646a15738d517c5d8a31e09981c14dd5e6a48d98243fe0c60be12d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a495e38ecda131fdeb8dae8669972e9d5789e73ecf6a15b852ac4a466cba1ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4cfb20314f7433068535739e04c42e70a7ed51b019290df9ea728c96174b3d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00d0ce764da0ee4440877ae26c34cbcbfe61353e760c839ee2fd8d917b78b522"
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

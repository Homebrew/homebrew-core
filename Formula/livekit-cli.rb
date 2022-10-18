class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "35df3f6a50adffda3eee2b969d81cdae0e1ddd461c1c266142eeae9bde3c2b09"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55e527002abf767b6afd21e622aef6da4880d867cf475402cc82281cfc6f25c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24fc83681f4ea23f34683eb0ee456cd4e52362662db479956581e62210867953"
    sha256 cellar: :any_skip_relocation, monterey:       "93d1e79c05833ecdce49504a6233584718cefbc059d3ffa9cd47de18511ccad9"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b0a0360d3ac59ca3249f66720094110577c015b32d241d65fc6493ab6758ec9"
    sha256 cellar: :any_skip_relocation, catalina:       "68fd4bc461c5f1e5080d17c2fa338cc2e34d5ec11d6e6b9a7088885e243cbe5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d9e3b9671d63b53c183b6b30097f928af856722b2bdfde009119f446c0f482f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/livekit-cli"
  end

  test do
    output = shell_output("#{bin}/livekit-cli create-token --list --api-key key --api-secret secret")
    assert output.start_with?("valid for (mins):  5")
    assert_match "livekit-cli version #{version}", shell_output("#{bin}/livekit-cli --version")
  end
end

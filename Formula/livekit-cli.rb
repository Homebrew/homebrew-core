class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "06378b0a4e440eed7fd2df8daefe464c5425ffdb6d7220b141215f1f51f3e527"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "669ed7e79234544abafb79d63ae968998b178ebb8f67c3587fc8cd846bc906fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cfb0a243e4c1fa8e49494ce59cc5b4653e9f920cd5b498647f00b0ddcb62cc10"
    sha256 cellar: :any_skip_relocation, monterey:       "d53bb333e28040332c62dcc978df80fac3da7e5580066b8d2a9cab1680ab50fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "dae9f45ed63d3f93058011208f8d0bfea44962a5d28cab64dca7c24a2c8309d2"
    sha256 cellar: :any_skip_relocation, catalina:       "1496d33ab62c79c332b613f243699a0fd4dc41ffd17c3b949cd2bcc1dfd8a82f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e0ee189d3d9854d30cd55354d0e81180471e85c680ca8ce506926d87b72a0de"
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

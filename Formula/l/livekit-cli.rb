class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v1.2.8.tar.gz"
  sha256 "8396c4c302bf7a5e3ad7ac26b4cf0c5dff51ae6955f273a564510963ec0c4ebb"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e58f8807cfdc2c2bcae5d7101baccdfd4b7bbc81485eb5be54e46766fa34fba0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c919eb115df7facd86bf014a3a429615e12c5081d42b6af7d7e74d2643b80cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8e54d009b3e51ae24511219359d0b697f62977a6379b73351a21b2d798d2814"
    sha256 cellar: :any_skip_relocation, ventura:        "2d1e788550a13cbc11a047e03bff3915b20f0bec58c4e1f9068b07f8950df03a"
    sha256 cellar: :any_skip_relocation, monterey:       "18a583a15b3f585852a5a046c4a05242b8cceea50677dbba63f19c02bce6f3c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a78c16ac871e202b88376c576d08878204ca2cb1ff55ee4aa6cff17ef63e97a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "359f6d070fc58de12c32a844d78206fe5a26957e6399cf76b505d468ba13575c"
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

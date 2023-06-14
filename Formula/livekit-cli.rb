class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v1.2.6.tar.gz"
  sha256 "5a3f66d0d4326366ce6eca4b06b3b38b724327d4e234c43555de527da0fd8956"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6df6fbf7373e1edbbd87bb54ae91f9a7f9317a60528150b901d5b5aaf1a449fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "645cb040c8ec47b611b1a243277b8db1dc85cb649625d6169f3fc7396304771a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0755bd5d1e0970262a8c3f7db77deafac492c3ae23ffa1b95661815c4be24238"
    sha256 cellar: :any_skip_relocation, ventura:        "2ae1c9d498a0859aaa33768e51d4b7d42618c39402a68fbeada631abe1069acc"
    sha256 cellar: :any_skip_relocation, monterey:       "8a3da1e5cb3c1a411cdbfbb1ea0136b907f0d9c6bf31d997b748e6a3a74fcb51"
    sha256 cellar: :any_skip_relocation, big_sur:        "aae887750a4cd0a59adb8f17ce6d46938d32391e9279293da37a5a18eda1dc3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ad718c7cf508587b97358a92173e8eb110662ffc66707541df5e0a2c3e18e87"
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

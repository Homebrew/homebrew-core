class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "87196347bdbad99daf404f7fa3f6e58e431ad829d1db6765b7f6d7d81ede7aa0"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/livekit-cli"
  end

  test do
    output = shell_output("#{bin}/livekit-cli create-token --list --api-key key --api-secret secret")
    assert output.start_with?("valid for (mins):  5")
  end
end

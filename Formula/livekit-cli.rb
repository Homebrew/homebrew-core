class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "6c3102aa027d8d8f735fff4e16608e91227497650aa93f07ea0d8d1111f98f9d"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

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

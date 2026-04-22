class OnecliCli < Formula
  desc "Manage agents, secrets, and configuration from the terminal"
  homepage "https://github.com/onecli/onecli-cli"
  url "https://github.com/onecli/onecli-cli/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "0c5b712553107f49fc8bf6489ea045dbab41867e4fb4ba82df69a6fbd740b3d7"
  license "Apache-2.0"
  head "https://github.com/onecli/onecli-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"onecli"), "./cmd/onecli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/onecli version")
  end
end

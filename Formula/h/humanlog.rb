class Humanlog < Formula
  desc "Logs for humans to read"
  homepage "https://github.com/humanlogio/humanlog"
  url "https://github.com/humanlogio/humanlog/archive/refs/tags/v0.7.8.tar.gz"
  sha256 "9984db35260541fbd1a8abe6b09fd2e30c9d77df3210087ffe04d72308bf9860"
  license "Apache-2.0"
  head "https://github.com/humanlogio/humanlog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d6961f97679cd60e5daea54d66d4871d09ed3e2e2e177c923beef103a5b9be2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30a4d5c09d7377042984416f3900935466b3b52e3556bc3461355408ab066b3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ad903812e6b1259b8e40cca1ef068e1a6e3d629e1e8cceaaef7aa172daebca0"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3e3c93702f5021ff7837951031ead94f17691a2da8bf00a9f171975ea11f8b9"
    sha256 cellar: :any_skip_relocation, ventura:       "7a904fd16a989f23d0fbaaeaf9db8dddd282930ded9d099ee65a19af9c57a090"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "887c3114786e53c69ef3f3be987b63df76caac4199e15547349eb21a03d0e3f0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.versionMajor=#{version.major}
      -X main.versionMinor=#{version.minor}
      -X main.versionPatch=#{version.patch}
      -X main.versionPrerelease=
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/humanlog"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/humanlog --version")

    test_input = '{"time":"2024-12-23T12:34:56Z","level":"info","message":"brewtest log"}'
    expected_output = "brewtest log"

    output = pipe_output(bin/"humanlog", test_input)
    assert_match expected_output, output
  end
end

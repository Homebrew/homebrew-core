class Humanlog < Formula
  desc "Logs for humans to read"
  homepage "https://github.com/humanlogio/humanlog"
  url "https://github.com/humanlogio/humanlog/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "b397c8e064e7d694a4e01952ac66b04d7417cd2087d6ef36a6004427a771293f"
  license "Apache-2.0"
  head "https://github.com/humanlogio/humanlog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c34afe2c52ede69a0db3825b9968afc0918e1d4a7f95b312801a56f93921e083"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8350647afe1cb12885d3761a2f2c0d6d33e0ecbd72ecb6daef995cadd1ddb20"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4120f04a15429515c67e19c44622f3eacec075e94bd8aef12da03a57b410fd7"
    sha256 cellar: :any_skip_relocation, sonoma:        "7424703c58ebb63f7150964260a9d8c564484bce9cfcacd624ffb73ad531edda"
    sha256 cellar: :any_skip_relocation, ventura:       "bc2d26af3850112ce23d4cf1b683b911e8a116d2d0ad36e194fd7e9a9e806e91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f919176f962835c7323f0676095a6caf765732c4fa2a2c30dba4558b4dfaaa9"
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

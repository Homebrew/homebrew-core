class Goawk < Formula
  desc "POSIX-compliant AWK interpreter written in Go"
  homepage "https://benhoyt.com/writings/goawk/"
  url "https://github.com/benhoyt/goawk/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "997225c30c544eeccb31487d69f34e736d8027269d74b1173e82dd62a545b8d3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "325dc7f2e4e65dbc964cba75b6d6f463c597dab147630d358f3ec484bc3e4b4b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "325dc7f2e4e65dbc964cba75b6d6f463c597dab147630d358f3ec484bc3e4b4b"
    sha256 cellar: :any_skip_relocation, monterey:       "2a1042f04d365700aab018101bf82579226c3a7f45f4670bcc2d89f30d80721e"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a1042f04d365700aab018101bf82579226c3a7f45f4670bcc2d89f30d80721e"
    sha256 cellar: :any_skip_relocation, catalina:       "2a1042f04d365700aab018101bf82579226c3a7f45f4670bcc2d89f30d80721e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b89dbb0d55dbc5dac7172545659f3b84100db7842c3ccc858b4f21ec15fbeee"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = pipe_output("#{bin}/goawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end

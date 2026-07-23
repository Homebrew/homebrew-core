class Qshell < Formula
  desc "Shell Tools for Qiniu Cloud"
  homepage "https://github.com/qiniu/qshell"
  url "https://github.com/qiniu/qshell/archive/refs/tags/v2.19.10.tar.gz"
  sha256 "bdc8de05e306d4f038942ca229a5a5bb12568f605c59e18ab6bf638b4f767680"
  license "MIT"
  head "https://github.com/qiniu/qshell.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6411fe4e51cbfec3878796404b92885c0b5aaa14130dfea07ce22f022b362b06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6411fe4e51cbfec3878796404b92885c0b5aaa14130dfea07ce22f022b362b06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6411fe4e51cbfec3878796404b92885c0b5aaa14130dfea07ce22f022b362b06"
    sha256 cellar: :any_skip_relocation, sonoma:        "15c4e4608e5b1090536a65ebeba65d562e1e49ed00be53dc4db221dc9908fb5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cac560e36727828d56b8efe9d3f47de6e6aab966ff1f6807a94c556723a0ce7"
    sha256 cellar: :any,                 x86_64_linux:  "7754a2b342bf579818cfd3972ef21ad2b35ef30b9168b903a1711f60f08113ee"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/qiniu/qshell/v2/iqshell/common/version.version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./main"
    generate_completions_from_executable(bin/"qshell", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output "#{bin}/qshell -v"
    assert_match "qshell version v#{version}", output

    # Test base64 encode of string "abc"
    output2 = shell_output "#{bin}/qshell b64encode abc"
    assert_match "YWJj", output2
  end
end

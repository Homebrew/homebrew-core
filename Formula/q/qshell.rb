class Qshell < Formula
  desc "Shell Tools for Qiniu Cloud"
  homepage "https://github.com/qiniu/qshell"
  url "https://github.com/qiniu/qshell/archive/refs/tags/v2.19.13.tar.gz"
  sha256 "3b9a963441475cdf3ffebcb09db9a5f60a1fea9263f2ea680a9f1c479abf2cca"
  license "MIT"
  head "https://github.com/qiniu/qshell.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a2ddbf4449594fe38678ac4f64441585eae016cffd9c0f312ec738cc2b7e15d1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a2ddbf4449594fe38678ac4f64441585eae016cffd9c0f312ec738cc2b7e15d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a2ddbf4449594fe38678ac4f64441585eae016cffd9c0f312ec738cc2b7e15d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a703e7acad931ad5ee26cd96d97626c4b96bcd11986e74cc16516fe8d9ee37aa"
    sha256 cellar: :any,                 x86_64_linux:      "5f179170061cdffa35bf76a38e4a6ccb91a0979ed18698f91cab1c39741a08b1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/qiniu/qshell/v2/iqshell/common/version.version=v#{version}]
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

class Qshell < Formula
  desc "Shell Tools for Qiniu Cloud"
  homepage "https://github.com/qiniu/qshell"
  url "https://github.com/qiniu/qshell/archive/refs/tags/v2.21.0.tar.gz"
  sha256 "13fd7aa7b6eb980541cfff49a94d9fececa324ffef67a20e763fc7b5ea5ba738"
  license "MIT"
  head "https://github.com/qiniu/qshell.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2db1edd858d6c7e0a20bce8c7f3cb085037afe5abed013a053b7fa26009422a5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2db1edd858d6c7e0a20bce8c7f3cb085037afe5abed013a053b7fa26009422a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2db1edd858d6c7e0a20bce8c7f3cb085037afe5abed013a053b7fa26009422a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fbb5aedcbe759f7b59657250ab204e0a602ad61aa713c2377f3d8130caee43b1"
    sha256 cellar: :any,                 x86_64_linux:      "06fb2802d7c865393b26255315db999dabb5ac9f1d5bf010fa97e090d9100a06"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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

class Qshell < Formula
  desc "Shell Tools for Qiniu Cloud"
  homepage "https://github.com/qiniu/qshell"
  url "https://github.com/qiniu/qshell/archive/refs/tags/v2.18.0.tar.gz"
  sha256 "fae782559275e2da0bffd2c874897cb34db102e73d7a3120d52c536582d4688e"
  license "MIT"
  head "https://github.com/qiniu/qshell.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4654e40c4b523f7dfe0d1e94877bb6a2cd14012bc96d8f134762e7bac46530c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4654e40c4b523f7dfe0d1e94877bb6a2cd14012bc96d8f134762e7bac46530c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4654e40c4b523f7dfe0d1e94877bb6a2cd14012bc96d8f134762e7bac46530c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "0aa8d4f3b4e253fb48ae90dae1d82f541cd47e30c8653c8ff9c2b93ba65ce829"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e99dba31317d201b718340766f382d3187ac823a9b6a71af84706f94a7717a39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ee4f843548a80b09efff872644392339d847ee8e70d9ca916b2a367ea9850b3"
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

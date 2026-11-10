class Qshell < Formula
  desc "Shell Tools for Qiniu Cloud"
  homepage "https://github.com/qiniu/qshell"
  url "https://github.com/qiniu/qshell/archive/refs/tags/v2.21.1.tar.gz"
  sha256 "b56471e93294a106bd3812c973c7257fece91649d6d7028b7d9285bf5858ed45"
  license "MIT"
  head "https://github.com/qiniu/qshell.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e5c48f43ba9109687b5e9bceb2007e89c60991f9a4f32bfc5e3b84c298534bc2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e5c48f43ba9109687b5e9bceb2007e89c60991f9a4f32bfc5e3b84c298534bc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e5c48f43ba9109687b5e9bceb2007e89c60991f9a4f32bfc5e3b84c298534bc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4f22082fe1d13be578303936c21d3a4848df52f1e140f4b8f12ffd2800f4c57b"
    sha256 cellar: :any,                 x86_64_linux:      "87423a8c4846c875cdd95e83f5fe111ce9732666c05cb1499f6302a0cb334dd8"
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

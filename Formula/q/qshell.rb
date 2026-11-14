class Qshell < Formula
  desc "Shell Tools for Qiniu Cloud"
  homepage "https://github.com/qiniu/qshell"
  url "https://github.com/qiniu/qshell/archive/refs/tags/v2.21.2.tar.gz"
  sha256 "f3978eef5f49647c5843ae15b88c0b884fc11b4372b7e9249758c2eb215ba7c6"
  license "MIT"
  head "https://github.com/qiniu/qshell.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e3f123debfc70e9659c16d0545a25da0a9979e1e0fdfdda12a2d1aa4921d0d73"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e3f123debfc70e9659c16d0545a25da0a9979e1e0fdfdda12a2d1aa4921d0d73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e3f123debfc70e9659c16d0545a25da0a9979e1e0fdfdda12a2d1aa4921d0d73"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2d6c1668566b44629834328e19f12bbfb30efa1749a321e99a246d218dab1b43"
    sha256 cellar: :any,                 x86_64_linux:      "6906b407cbb2a7e927ff63d6f6e1f6796b64fb7864e5b8d883fa4c1f3ba4ae4b"
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

class Qshell < Formula
  desc "Shell Tools for Qiniu Cloud"
  homepage "https://github.com/qiniu/qshell"
  url "https://github.com/qiniu/qshell/archive/refs/tags/v2.21.0.tar.gz"
  sha256 "13fd7aa7b6eb980541cfff49a94d9fececa324ffef67a20e763fc7b5ea5ba738"
  license "MIT"
  head "https://github.com/qiniu/qshell.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "144739940a4759dcbb67f43e3b43f981aac015d3009d0ae80848efab688360e8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "144739940a4759dcbb67f43e3b43f981aac015d3009d0ae80848efab688360e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "144739940a4759dcbb67f43e3b43f981aac015d3009d0ae80848efab688360e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8c275cbdb956d046743c2d762b9dccc30c09f3153193e2f54b7f04cb5ac78a15"
    sha256 cellar: :any,                 x86_64_linux:      "4504cf9185549a3f31fe40c04bc2da3f7d6beacb6e0785880b43aa9a2740719a"
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

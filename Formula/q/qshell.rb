class Qshell < Formula
  desc "Shell Tools for Qiniu Cloud"
  homepage "https://github.com/qiniu/qshell"
  url "https://github.com/qiniu/qshell/archive/refs/tags/v2.19.7.tar.gz"
  sha256 "9ed3f5da59291af41200ba124c4fc15ba996182c1617f64ef3920a344651d1c4"
  license "MIT"
  head "https://github.com/qiniu/qshell.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89175f20d38eb8bb3e700f23215456797029aae6d6110e3cd0c0bc46534edf59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89175f20d38eb8bb3e700f23215456797029aae6d6110e3cd0c0bc46534edf59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89175f20d38eb8bb3e700f23215456797029aae6d6110e3cd0c0bc46534edf59"
    sha256 cellar: :any_skip_relocation, sonoma:        "364bb72c22d2939840d813fb87400d999c83bde839b45eb4bb62389654c8c667"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8ccd01c6299ad8e3cb28bac4c1a60d6e2f8f25f4ec7f02733ed3268bb572132"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "709e76134ec6e82ee64fd111415692968a14424da9082f20dee85aa99260f54b"
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

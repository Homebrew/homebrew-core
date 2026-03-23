class Qshell < Formula
  desc "Shell Tools for Qiniu Cloud"
  homepage "https://github.com/qiniu/qshell"
  url "https://github.com/qiniu/qshell/archive/refs/tags/v2.19.0.tar.gz"
  sha256 "644d15592f653f2287a9b257ba3c92ddbadf7983500aab2c2eaed4bec366de75"
  license "MIT"
  head "https://github.com/qiniu/qshell.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf1579c9c77c564eda9f0ed38af81e9e4b78b3d2caa6b25a51a20ebaf4a9a52d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf1579c9c77c564eda9f0ed38af81e9e4b78b3d2caa6b25a51a20ebaf4a9a52d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf1579c9c77c564eda9f0ed38af81e9e4b78b3d2caa6b25a51a20ebaf4a9a52d"
    sha256 cellar: :any_skip_relocation, sonoma:        "59b544f3d82acab67f59c2d9264a29929f5de03a2deb54eacc15b257df99b224"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc76fa4418141e49a17f1cb64ad3de7c6f0a61e5985eb30716802b776bc02831"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85ae149838896686365cf8e291ab3f1c1871f77515dc11ed4bc4fabe205f1477"
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

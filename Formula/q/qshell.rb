class Qshell < Formula
  desc "Shell Tools for Qiniu Cloud"
  homepage "https://github.com/qiniu/qshell"
  url "https://github.com/qiniu/qshell/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "bec44991966fc6a80a0dc7d0cbb95bfdbd607819a6b63c60d87e56a30a51eb54"
  license "MIT"
  head "https://github.com/qiniu/qshell.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e79fd5f72ab3054fd605c2f8e50c3b48e58f239a3dba75d9a3b037c8fd19f41a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e79fd5f72ab3054fd605c2f8e50c3b48e58f239a3dba75d9a3b037c8fd19f41a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e79fd5f72ab3054fd605c2f8e50c3b48e58f239a3dba75d9a3b037c8fd19f41a"
    sha256 cellar: :any_skip_relocation, sonoma:        "44d3b7a9558ed3e546354e4cc67f4230af7a5f365db3f30559786f908bee919a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93b3ab94a6322e0d3d60de34505a64cf47a3f38d4a9cfa7599200aa06228958b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c06438485e2f86d051b1b46381375446f8c8cb427ffe909edc8847263134a94"
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

class Qshell < Formula
  desc "Shell Tools for Qiniu Cloud"
  homepage "https://github.com/qiniu/qshell"
  url "https://github.com/qiniu/qshell/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "bec44991966fc6a80a0dc7d0cbb95bfdbd607819a6b63c60d87e56a30a51eb54"
  license "MIT"
  head "https://github.com/qiniu/qshell.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce07308d88f9806d46d900bb9639ada162253566afacb2cf744cd22047591553"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce07308d88f9806d46d900bb9639ada162253566afacb2cf744cd22047591553"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce07308d88f9806d46d900bb9639ada162253566afacb2cf744cd22047591553"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7507895ad710a5710fc9fb34f60f5773b7284ed487b656dd98df7d0a43e28bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74f10c26dba48c41c8f3a20f9d3a58ad1466088bb5a69555b2b1d64bc0917ead"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98ec759ed78f6e1b0aab976a5b7d3b0079c138da54c4648680aa0848529ec59d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/qiniu/qshell/v2/iqshell/common/version.version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./main"
    generate_completions_from_executable(bin/"qshell", "completion")
  end

  test do
    output = shell_output "#{bin}/qshell -v"
    assert_match "qshell version v#{version}", output

    # Test base64 encode of string "abc"
    output2 = shell_output "#{bin}/qshell b64encode abc"
    assert_match "YWJj", output2
  end
end

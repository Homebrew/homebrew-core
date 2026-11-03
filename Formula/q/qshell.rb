class Qshell < Formula
  desc "Shell Tools for Qiniu Cloud"
  homepage "https://github.com/qiniu/qshell"
  url "https://github.com/qiniu/qshell/archive/refs/tags/v2.20.0.tar.gz"
  sha256 "bc896943712b133251d00a0a0ed5ca551ef366272cbb803addfe0fcb41b3825b"
  license "MIT"
  head "https://github.com/qiniu/qshell.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "877d4db95634c40c09f7c10808bbccbe4ef05ff56aa146eb2254e853f43ea2e7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "877d4db95634c40c09f7c10808bbccbe4ef05ff56aa146eb2254e853f43ea2e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "877d4db95634c40c09f7c10808bbccbe4ef05ff56aa146eb2254e853f43ea2e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2b8a5ebb9b961ece00c358729f1af2d14b331ef9be4ea46f686ca8f1d267fb65"
    sha256 cellar: :any,                 x86_64_linux:      "e0b9931ebd5e19fdff4f191c43a6d841c4f618c79bb0ee515672e39a8ca615e7"
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

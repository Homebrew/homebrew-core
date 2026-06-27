class Qshell < Formula
  desc "Shell Tools for Qiniu Cloud"
  homepage "https://github.com/qiniu/qshell"
  url "https://github.com/qiniu/qshell/archive/refs/tags/v2.19.8.tar.gz"
  sha256 "93a865e9186b6e9c7e4d404e6bc609ae76fef9ff499a70d7b954062585045a02"
  license "MIT"
  head "https://github.com/qiniu/qshell.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6824bf302f3b943453042b57c17eb926af95ad9d51cc07430f7d5f6e5bd795f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6824bf302f3b943453042b57c17eb926af95ad9d51cc07430f7d5f6e5bd795f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6824bf302f3b943453042b57c17eb926af95ad9d51cc07430f7d5f6e5bd795f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "812003f767a1085d0a7a52cfba69eb1d87f235afb7ba49c7a1e93cf278373627"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fffe8d950e29065046d45ef5e5f2aba9ab34725cf141580370a71ec8a678ef00"
    sha256 cellar: :any,                 x86_64_linux:  "829c6194368fd3d13ce1ec24e6bfbcf5d929bbc6bfb69ed932e10440edbccd77"
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

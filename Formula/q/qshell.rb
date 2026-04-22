class Qshell < Formula
  desc "Shell Tools for Qiniu Cloud"
  homepage "https://github.com/qiniu/qshell"
  url "https://github.com/qiniu/qshell/archive/refs/tags/v2.19.3.tar.gz"
  sha256 "f588ba8c9eb69074d6e6f072a46b29086aedf45d2b072a7c9e088110009f6ff4"
  license "MIT"
  head "https://github.com/qiniu/qshell.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a47c40c74b1b48eade89ab7099908e28ba6483e6cd0349973e71d285733e9d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a47c40c74b1b48eade89ab7099908e28ba6483e6cd0349973e71d285733e9d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a47c40c74b1b48eade89ab7099908e28ba6483e6cd0349973e71d285733e9d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "1bd596fa474f00528d185c118f56598688e55d704c5ec3231e2c1637beb7a40f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "446fe6456cb257031dc21bd92ad18080c97836dd2cfc116320d224484093d2dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48f87748efe2d1bd3614d5b34a0beb2ea176bdabc93368485955c517deaa06e8"
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

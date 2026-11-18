class Qshell < Formula
  desc "Shell Tools for Qiniu Cloud"
  homepage "https://github.com/qiniu/qshell"
  url "https://github.com/qiniu/qshell/archive/refs/tags/v2.22.1.tar.gz"
  sha256 "3349a7b359da0b5e92705f126783b9a88e8a58fa8d47106aeae60e9ed6b5ad62"
  license "MIT"
  head "https://github.com/qiniu/qshell.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "602ebaed92b790db5809b692abdd7573af4a02232b301e3cf7889cdb783c0229"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "602ebaed92b790db5809b692abdd7573af4a02232b301e3cf7889cdb783c0229"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "602ebaed92b790db5809b692abdd7573af4a02232b301e3cf7889cdb783c0229"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b3125e0e2d5a26785be081af1dc5121dadda015c3806733783f019e95457e865"
    sha256 cellar: :any,                 x86_64_linux:      "a9f8d86e34bdb505272afb1b548910a59f34a003b23db81a5a1e2ab1547b3776"
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

class Qshell < Formula
  desc "Shell Tools for Qiniu Cloud"
  homepage "https://github.com/qiniu/qshell"
  url "https://github.com/qiniu/qshell/archive/refs/tags/v2.19.9.tar.gz"
  sha256 "5bf789e3b23e52df0b34c06d3faadb55cf057bdb7226de4aa06f40f3d21ea9d5"
  license "MIT"
  head "https://github.com/qiniu/qshell.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c0ef5d120623e7255ce89c0e7db2eee0fa15006afc4ab0cd3330b94ba5dc054"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c0ef5d120623e7255ce89c0e7db2eee0fa15006afc4ab0cd3330b94ba5dc054"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c0ef5d120623e7255ce89c0e7db2eee0fa15006afc4ab0cd3330b94ba5dc054"
    sha256 cellar: :any_skip_relocation, sonoma:        "4379ac815206cf723c2314ac8495146448216e58d99534e081f36f73827d5d2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6778577d18a795a9216ad3dc76ba0ac76bc2d465ac26aff2b13d31460475b923"
    sha256 cellar: :any,                 x86_64_linux:  "78e3c9e5bfffbb1a2d5e22b30851577ca0eb0c6030e651c6d01adb1c3007e03d"
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

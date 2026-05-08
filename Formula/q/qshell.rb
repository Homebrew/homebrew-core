class Qshell < Formula
  desc "Shell Tools for Qiniu Cloud"
  homepage "https://github.com/qiniu/qshell"
  url "https://github.com/qiniu/qshell/archive/refs/tags/v2.19.6.tar.gz"
  sha256 "4f03d2400440d1af6b597de42a6a9469417238a43a5c2a1954fcd7c660970c3e"
  license "MIT"
  head "https://github.com/qiniu/qshell.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0b2accf4f95abfa44bdd6cf5da5e447516e425f55da8a57b4cbdab02310db8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0b2accf4f95abfa44bdd6cf5da5e447516e425f55da8a57b4cbdab02310db8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0b2accf4f95abfa44bdd6cf5da5e447516e425f55da8a57b4cbdab02310db8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3dae632ee45c16f09d7213d7b20ff54dcc135bdb47fe639b37a874e6d9a6a41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28d9e4c0095965f4ba82a1280aa5fc1ae7c35620dc3279455438e2bd57b1cbf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afdcde4c44431f5f0ad8a2c0a8f69e5ecff0b5deacc41fd5869edce992f3f222"
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

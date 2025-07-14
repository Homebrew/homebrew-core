class Qshell < Formula
  desc "Shell Tools for Qiniu Cloud"
  homepage "https://github.com/qiniu/qshell"
  url "https://github.com/qiniu/qshell/archive/refs/tags/v2.16.1.tar.gz"
  sha256 "40748fe8f194111e94bc6cc483c71f19c07575133e8d356df06d47d67fa4e8c6"
  license "MIT"
  head "https://github.com/qiniu/qshell.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d40bdded5fa597ae35519b8c1d130d9fdd2ba831b8b7607ca3c892a4d98df63a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d40bdded5fa597ae35519b8c1d130d9fdd2ba831b8b7607ca3c892a4d98df63a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d40bdded5fa597ae35519b8c1d130d9fdd2ba831b8b7607ca3c892a4d98df63a"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb202dbbeefd821950a549a7bfa5f60e90ff33795752d426ed063f98fe2242a9"
    sha256 cellar: :any_skip_relocation, ventura:       "fb202dbbeefd821950a549a7bfa5f60e90ff33795752d426ed063f98fe2242a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7c7b373ea3d5ca50d4e48d844aebece5ea22a4d959a02833822e1a14915d17c"
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

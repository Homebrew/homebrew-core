class Gaze < Formula
  desc "Execute commands for you"
  homepage "https://github.com/wtetsu/gaze"
  url "https://github.com/wtetsu/gaze/archive/refs/tags/v1.1.6.tar.gz"
  sha256 "3fd0ab0b3451e78b85bf2104d5b23b3c4d018cc8f2ed824e103761f8a327c713"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "df60118226195a00b1de47aa613f2dcc6dfcfa979db937a0ba19074538261b93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df2807922eaf5decd4f5dca7b979e7c83ab039c82dfdd6e94899656512341b2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e5652b24e3da96ec9085d07c4b776b8fa8ebb6315bf5ce8c98361200d1f71b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e5652b24e3da96ec9085d07c4b776b8fa8ebb6315bf5ce8c98361200d1f71b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e5652b24e3da96ec9085d07c4b776b8fa8ebb6315bf5ce8c98361200d1f71b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "65d1da1399d000e7565b3fb49c7015a094f8bf7f840711857e189852b3f64d18"
    sha256 cellar: :any_skip_relocation, ventura:        "883b90c8117e35667b597728ceb2d23106ab6021fcd920055d85e6230dc74539"
    sha256 cellar: :any_skip_relocation, monterey:       "883b90c8117e35667b597728ceb2d23106ab6021fcd920055d85e6230dc74539"
    sha256 cellar: :any_skip_relocation, big_sur:        "883b90c8117e35667b597728ceb2d23106ab6021fcd920055d85e6230dc74539"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f7c23c489737fd48d591e6093ab500dd9614706e8c98179d65273aad343a84c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "cmd/gaze/main.go"
  end

  test do
    pid = fork do
      exec bin/"gaze", "-c", "cp test.txt out.txt", "test.txt"
    end
    sleep 5
    File.write("test.txt", "hello, world!")
    sleep 2
    Process.kill("TERM", pid)
    assert_match("hello, world!", File.read("out.txt"))
  end
end

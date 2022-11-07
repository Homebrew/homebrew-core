class Gaze < Formula
  desc "Execute commands for you"
  homepage "https://github.com/wtetsu/gaze"
  url "https://github.com/wtetsu/gaze/archive/refs/tags/v1.1.5.tar.gz"
  sha256 "e954f074bcd3e7f8c898bf83faecfe5f2acff7001f1001157798c9e723916aab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8922e80356625e243436d0011ea25972ef9c222eb298ec0aeee4b4f39f3d6c90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4fbbd1eb6ed6c25371afb08b29321e7a80ac61fc7e1a298d44c656b5d624ff8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30de0ed96d4ca867887bc06f21357e038a7689c4fb9775a2126ee883d0d5d3fd"
    sha256 cellar: :any_skip_relocation, monterey:       "1c563c22a24a0fa3012977b13356cb6b0656650a038ca140a83d6b522106c00a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1a9fe43258b66e3e0c4e4f1711615bb5473caad59b6e6e089c76ad7869143f0"
    sha256 cellar: :any_skip_relocation, catalina:       "a0d10ca675a0fbb0eec00b38c62035e0149cc621a3e92c029728697f280f574c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb5032702004874bfc54ed0ffa72d35c16af30d96a15e14efdf49a721ae633d7"
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

class Gaze < Formula
  desc "Execute commands for you"
  homepage "https://github.com/wtetsu/gaze"
  url "https://github.com/wtetsu/gaze/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "02bac4bfeded4e8e951af2d255a26ea3554dbbf4fd124cc9cfad5e29265e0a4d"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmd/gaze/main.go"
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

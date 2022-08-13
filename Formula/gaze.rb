class Gaze < Formula
  desc "Execute commands for you"
  homepage "https://github.com/wtetsu/gaze"
  url "https://github.com/wtetsu/gaze/archive/refs/tags/v1.1.1a.tar.gz"
  version "1.1.1a"
  sha256 "8364648dbe55c069db71e9e943ef8a1225aa4b4896af5be65b923128e34400ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcc5376767d8967574e34cab01548c2bd18334425bab843cb9d5c1bdca2c3534"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1bf19f01c4c3be1eda780a9f4318453fadde3a719634c93049ac9a2eaba2b658"
    sha256 cellar: :any_skip_relocation, monterey:       "f661e00d7b3ce2981d25b9b678a5a9a737b6a392bd281d40c67fb247e4df21d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e40eac0fccc67d48ef0bae1f7477dd1fe13db949afb17fe6d08791fcb7029be"
    sha256 cellar: :any_skip_relocation, catalina:       "bfb9d2695e93863c6cfb44f657a97d36d93b6b577e0f326132179b3043999e66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb0ee917847513e3e05f1973b195d9b4c4d5a409babc621e5679b705bccece20"
  end

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

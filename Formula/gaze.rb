class Gaze < Formula
  desc "Execute commands for you"
  homepage "https://github.com/wtetsu/gaze"
  url "https://github.com/wtetsu/gaze/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "53c46a09f477433e9105b9df8db9ddf287fae6734b3078d79f5f994500e8625d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7d7858554a31fb35c18208505406ef87bbd5ae9d0c611dbb7bd2b922434a2e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b44413b9439372a8df04dfc191969dbf6ffedce7a25f7b4ad2058884f8f4cc8"
    sha256 cellar: :any_skip_relocation, monterey:       "28f18859a123f1b06349300bc40b6d6249475ea3e0089ef8b57af0b25e14ab75"
    sha256 cellar: :any_skip_relocation, big_sur:        "5dc7683e7f6eb8e6618c44fd7c10f3cb9cbf032e12019f46002f905d03adef3e"
    sha256 cellar: :any_skip_relocation, catalina:       "b383861277696943cc637867be5ef4b3fa0191ddd0306f090b52c1184dfbaeaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a157686c0439af0073554c8cbc5a7b6c93cb8a8476175e74d0dab39d5f5a7600"
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

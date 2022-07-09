class Gops < Formula
  desc "Tool to list and diagnose Go processes currently running on your system"
  homepage "https://github.com/google/gops"
  url "https://github.com/google/gops/archive/refs/tags/v0.3.25.tar.gz"
  sha256 "48f6c37df596d4661e2594d6eadb358150e094140e752643cfb2819fa6597bcb"
  license "BSD-3-Clause"
  head "https://github.com/google/gops.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f678c6c4729125cceb088404cbfc44e4315d8be025c238a1a45d6ed0c0df3e57"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7cd17b58365d849b72b12e64e05a49aabd8f3185493d5112bed6127ccbe4b4c4"
    sha256 cellar: :any_skip_relocation, monterey:       "59eba621f999ca412798525cbbe60d606935c047b7fc3a32e76055f95a0801f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "d816b9a7b801f547f805aeb8c5f20b6ae16bc7e3cffe51d60c932c350eb9cba4"
    sha256 cellar: :any_skip_relocation, catalina:       "028e24f0cfd2c948c348ba25dee4a0dc99ebe2a3c5938771fb70444a25784b2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c3e9fd9e76a0ff1735343de60ff1f3e2c7184201b9917808d0b55ddb8793032"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"go.mod").write <<~EOS
      module github.com/Homebrew/brew-test

      go 1.18
    EOS

    (testpath/"main.go").write <<~EOS
      package main

      import (
        "fmt"
        "time"
      )

      func main() {
        fmt.Println("testing gops")

        time.Sleep(5 * time.Second)
      }
    EOS

    system "go", "build"
    pid = fork { exec "./brew-test" }
    sleep 1
    begin
      assert_match(/\d+/, shell_output("#{bin}/gops"))
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end

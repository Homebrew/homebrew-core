class Gops < Formula
  desc "Tool to list and diagnose Go processes currently running on your system"
  homepage "https://github.com/google/gops"
  url "https://github.com/google/gops/archive/refs/tags/v0.3.22.tar.gz"
  sha256 "a8092305465b28b0db83eb7087edca958de6522bc3ebb14656ecb8aef521e07b"
  license "BSD-3-Clause"
  head "https://github.com/google/gops.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5531dfba3e026925dd13fbcece02096a54e2ffb4179db48c0f5deb87d53923be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa0e48e32124e96c5cd3a46d905a5f9009fe5ad7a2177c0ab82cd5c6f8b18927"
    sha256 cellar: :any_skip_relocation, monterey:       "73a426fd2c973c1032b1da9e3492ccf04846be94af5eb471702e63addcd5b5ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "259cd5b92827f5b6ef3594a3beee292a5bc8c72bdba2d3c6fe3eb574205898a1"
    sha256 cellar: :any_skip_relocation, catalina:       "b73deb2fd695acb47f4de3b159a648230f0dc5f6e5816a9c1b76faa4919ce8f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82c7a434378ec9aad1f1c80c4cca5f98d9a357a969dadf0604ba85c285ad86e4"
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

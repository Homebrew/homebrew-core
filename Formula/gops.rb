class Gops < Formula
  desc "Tool to list and diagnose Go processes currently running on your system"
  homepage "https://github.com/google/gops"
  url "https://github.com/google/gops/archive/refs/tags/v0.3.22.tar.gz"
  sha256 "a8092305465b28b0db83eb7087edca958de6522bc3ebb14656ecb8aef521e07b"
  license "BSD-3-Clause"
  head "https://github.com/google/gops.git", branch: "master"

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

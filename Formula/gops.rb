class Gops < Formula
  desc "Tool to list and diagnose Go processes currently running on your system"
  homepage "https://github.com/google/gops"
  url "https://github.com/google/gops/archive/refs/tags/v0.3.25.tar.gz"
  sha256 "48f6c37df596d4661e2594d6eadb358150e094140e752643cfb2819fa6597bcb"
  license "BSD-3-Clause"
  head "https://github.com/google/gops.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3a667b5d5de1774d509cad3c9bc883f3cd47b74c20838d7fa34bc5cd1d72cda"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b7161a19fd9070a7a95beea0b9e2909629364247e155fd01c49ec22b37b8be1"
    sha256 cellar: :any_skip_relocation, monterey:       "3f23a3dd055cbd629212197ae27645bac34248aa78be9f5f9d3f894d52fad3bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8a98dab812edaf828a700b96e984f1a8029f92038356c69b3891adde4f3eebb"
    sha256 cellar: :any_skip_relocation, catalina:       "459c18679c4c53ccd7ad598308c2450e5038350770b0aa17e60c598024d20e37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cf6488fcb2af2df43c6832b851e504960a8951ea46321b14ed1f2543b3fe6fa"
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

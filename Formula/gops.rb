class Gops < Formula
  desc "Tool to list and diagnose Go processes currently running on your system"
  homepage "https://github.com/google/gops"
  url "https://github.com/google/gops/archive/refs/tags/v0.3.27.tar.gz"
  sha256 "1d5b8b0979c284d29d85f44aba6d0a5175059568aa698a242c5bc1d772263746"
  license "BSD-3-Clause"
  head "https://github.com/google/gops.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecd9424cc032ac9284d624d4073c23ab8757fdb4a55a7f8c7385d8d0904d2267"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "815c17c46ab42a3568b402880f086a45884f42dbb8addf1a1ab16fad8404ddcb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa9b882eceb26785e964ccbae13094255c221a151f3d42c0fc112535f26b0f2c"
    sha256 cellar: :any_skip_relocation, ventura:        "f4c5656e5f137daae4bcef99a71f6c10f2edf2dcfee26c4ed4603cd9f5abc813"
    sha256 cellar: :any_skip_relocation, monterey:       "1986c45a82376c07fa1ab0646b027ab6aed85f9c75ed1fcc0fff21edeab070ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "9525396fbc7888f003893eef06a7302bdc1e9f39354ad45b8cbbd34d18d183f5"
    sha256 cellar: :any_skip_relocation, catalina:       "82e7b45bce74679899c6aa5cd9cd8fc1160c80722f6d1a5fcf9a929c83ef1789"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e99ad7ed938797f5cc8ff3c1a35a3b78f4046dac2b668b6c1ff6c6f7f2244b0"
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

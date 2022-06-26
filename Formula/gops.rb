class Gops < Formula
  desc "Tool to list and diagnose Go processes currently running on your system"
  homepage "https://github.com/google/gops"
  url "https://github.com/google/gops/archive/refs/tags/v0.3.23.tar.gz"
  sha256 "7bea1780f7175d7518fb532a7ff858bc1789b88b918965068210ad8c5b8fd746"
  license "BSD-3-Clause"
  head "https://github.com/google/gops.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "900f69ef21b78825ca5229d77db7af860113ad46bd1a368ce94f87e97f221d4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5f21f7d0b67bb0fb22c949eca79b4f3d33055de37df00c8805444cf076bd33c"
    sha256 cellar: :any_skip_relocation, monterey:       "7c6fbc666eabaa1c0c6658d2d4d0e7082f9407367e331cb3641e4bcb9a616183"
    sha256 cellar: :any_skip_relocation, big_sur:        "15c92722429ac86e0d9d6ddee24e26cbda5a5468167a1259f5a4ab1eeaebe957"
    sha256 cellar: :any_skip_relocation, catalina:       "395a31c1ecfac22c97bcdc1169ba97536c73cdb69c23de4d85c88c0450804a8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91fac55763a20bbc6260c384fa7be4525b8f11f2871adcfa0187fe992cc3f129"
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

class Gops < Formula
  desc "Tool to list and diagnose Go processes currently running on your system"
  homepage "https://github.com/google/gops"
  url "https://github.com/google/gops/archive/refs/tags/v0.3.27.tar.gz"
  sha256 "1d5b8b0979c284d29d85f44aba6d0a5175059568aa698a242c5bc1d772263746"
  license "BSD-3-Clause"
  head "https://github.com/google/gops.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b962ab71b74211a8cc4d421450597e73300b8a66027d8b3fa8ad55557f53de2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c2bf5ee24c3ba38d15715d5a7e01c0aaad063fc6264303ea8522bd42be089ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f0f151581fd4308ba90ec3eb1dd62171fe40e9b3a0a04258b5793cb5167c9fd"
    sha256 cellar: :any_skip_relocation, ventura:        "809f885c8caf1b2f3b22dff4d33dfae0d2646c4a4b2291e4fb25d85c1fecb7df"
    sha256 cellar: :any_skip_relocation, monterey:       "8c134a4ed12158c406cd3483f9d0802ddb7277c44597a13e8b453c0e9e482cc8"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc9b769c28f074605a2c2c6e58493b4cfa4e4808018cbd9725ebf13326a687ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3499eec0a4fd2cf8fd974bde8c82ed9ec0c3b49566756b5a06f5f234e3d472db"
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

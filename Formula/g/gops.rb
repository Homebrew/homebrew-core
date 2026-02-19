class Gops < Formula
  desc "Tool to list and diagnose Go processes currently running on your system"
  homepage "https://github.com/google/gops"
  url "https://github.com/google/gops/archive/refs/tags/v0.3.29.tar.gz"
  sha256 "c4637684ac8efbcc0bc55faf64e3920a7764a9ae8f4580945084c1a5b8b2d051"
  license "BSD-3-Clause"
  head "https://github.com/google/gops.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0e45f2bd77fd4ab3a9c61d15957d454e78cc264800278668f527c9cd7599c98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58e8cde39bfc9198c6869823789fead52875cfd04ee543a0423f5134adb18a65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd76c2533b38aec86774444ce703bd107241191e8e512a6df9e732a1868502ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "d28c6659127578062c4f285e6c66fe7f423863921aaacd6db2aabf922077b70c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80580c60908ddfe547803f078eb5fc9d68f899401f3c3bf8fed5a564ea08cc64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69d835582184a7bf3c020e0212e211a70ae57d8dff0d6c540cd69efd2351cc40"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"gops", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"go.mod").write <<~GOMOD
      module github.com/Homebrew/brew-test

      go 1.18
    GOMOD

    (testpath/"main.go").write <<~GO
      package main

      import (
        "fmt"
        "time"
      )

      func main() {
        fmt.Println("testing gops")

        time.Sleep(5 * time.Second)
      }
    GO

    system "go", "build"
    pid = spawn "./brew-test"
    begin
      sleep 1
      assert_match(/\d+/, shell_output(bin/"gops"))
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end

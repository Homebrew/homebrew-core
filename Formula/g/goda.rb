class Goda < Formula
  desc "Go dependency analysis toolkit"
  homepage "https://github.com/loov/goda"
  url "https://github.com/loov/goda/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "ebaaea5f71363ee175d8f10591da199e3a7feaa3a96c18ddfada8dd9dec04058"
  license "MIT"
  head "https://github.com/loov/goda.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "683d29f3ff9e383188144b8b2d6a5252662a0a33d3cbb451c4c62fc3b31d1692"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "683d29f3ff9e383188144b8b2d6a5252662a0a33d3cbb451c4c62fc3b31d1692"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "683d29f3ff9e383188144b8b2d6a5252662a0a33d3cbb451c4c62fc3b31d1692"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "21809184328bb276af20bb5afd2af161e156016a3d9d27d892b2ed54bdd776d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d1cee4f5124eae9b485b3bc5a57e716a6f936be145aaccf51a30137b54dfd5b8"
  end

  # goda runs `go list` to load the packages it analyses
  depends_on "go" => [:build, :test]

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"go.mod").write <<~GOMOD
      module example.com/app
    GOMOD
    (testpath/"main.go").write <<~GO
      package main

      import "example.com/app/greeting"

      func main() {
        greeting.Greet()
      }
    GO
    (testpath/"greeting/greeting.go").write <<~GO
      package greeting

      func Greet() {
        println("hello")
      }
    GO

    output = shell_output("#{bin}/goda graph -type edges ./...").chomp
    assert_equal "example.com/app example.com/app/greeting", output
  end
end

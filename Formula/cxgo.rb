class Cxgo < Formula
  desc "Transpiling C to Go"
  homepage "https://github.com/gotranspile/cxgo"
  url "https://github.com/gotranspile/cxgo.git",
      tag:      "v0.3.4",
      revision: "d57c260fb00fa8bdae1c146f79dc03c4a13ae7c8"
  license "MIT"
  head "https://github.com/gotranspile/cxgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18d2bf86e86f57a86707fb779858f2be01ffc4c1e09a1f10bab20022f9292a1c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f648c7807d0b74585349a13f3537b495dc3b2136c9b6088af69ad1b19d6e14d9"
    sha256 cellar: :any_skip_relocation, monterey:       "48f9783fca70d866592960a52f4003e7a210f1625c28a371632ee1497bac7065"
    sha256 cellar: :any_skip_relocation, big_sur:        "7addcde45fdf2dfe8c2c694e636c36be1aff37afa33e962cc0732c4f7f903dea"
    sha256 cellar: :any_skip_relocation, catalina:       "a6e03349d1b041584bf5e42da1de44c10efd5c48d0bee2a8470cc934e32d7885"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4d2deba42fdd9df3a9bd5c959c4149f79d40d389ff5d2cc047bc0cec4da5338"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/cxgo"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main() {
        printf("Hello, World!");
        return 0;
      }
    EOS

    expected = <<~EOS
      package main

      import (
      \t"github.com/gotranspile/cxgo/runtime/stdio"
      \t"os"
      )

      func main() {
      \tstdio.Printf("Hello, World!")
      \tos.Exit(0)
      }
    EOS

    system bin/"cxgo", "file", testpath/"test.c"
    assert_equal expected, (testpath/"test.go").read

    assert_match version.to_s, shell_output("#{bin}/cxgo version")
  end
end

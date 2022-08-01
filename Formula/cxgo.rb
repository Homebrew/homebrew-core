class Cxgo < Formula
  desc "Transpiling C to Go"
  homepage "https://github.com/gotranspile/cxgo"
  url "https://github.com/gotranspile/cxgo.git",
      tag:      "v0.3.5",
      revision: "9e272a916d7885801ab4970e5f881fa890bdbe6a"
  license "MIT"
  head "https://github.com/gotranspile/cxgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc4e999c6066727547b5e2ea7391c70fd0457c0a5a48b65ffb6f281ef89d622c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ef46c289a0961764a7ab92d225ab1f076a949d02a561974c4d1273eaeac26d6"
    sha256 cellar: :any_skip_relocation, monterey:       "cffb8bf0c1f1704cc432c21b466afe56426beebb8168d9c19def54654b247cce"
    sha256 cellar: :any_skip_relocation, big_sur:        "d32a3894a5269db489c2d47277cbb9397c78b9e439084d428438283e5374722c"
    sha256 cellar: :any_skip_relocation, catalina:       "6072b4bca8b8f7b2ef412257c9a58ab76aec0ca873cb92d31c36a1d747005e3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "357879ed2c51c279b3d4e2a74dbe7db78a36b448af8a0377ac53a89c1297cc91"
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

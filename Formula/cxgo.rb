class Cxgo < Formula
  desc "Transpiling C to Go"
  homepage "https://github.com/gotranspile/cxgo"
  url "https://github.com/gotranspile/cxgo.git",
      tag:      "v0.3.7",
      revision: "cfc1ca865f59182eea902a45ce96b4cdda0f2b8c"
  license "MIT"
  head "https://github.com/gotranspile/cxgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01d2976616ed7156938f6162585a3c948d95cc949d49b97abc29bed8c381b136"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b5a70797d3f41c27dcb860fb1e35578a9f2d09cc50504f0bf04cde5797ed2f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "800b736a7731fda17e15de197a00562e70c863b62bd00afd9d216996efef6ecf"
    sha256 cellar: :any_skip_relocation, ventura:        "af5a140675ba61902c305c2be1ba5fbe7e83d12ec2d1cfb3648ea471af7f3cbb"
    sha256 cellar: :any_skip_relocation, monterey:       "eef11759db93aaeba729c7f76ccc73940f321c010446194ab42527fbce73ad2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "5db55c7ab63bdd7771b87c55a0e9ce64c6e60f9d588d1620a113451ee15554f0"
    sha256 cellar: :any_skip_relocation, catalina:       "6287342a8d7a37d461611a3382cfe09d6509c5e692ba5f1de4f54e19a569d01c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a8fb8c61c95813b7a8315c01c28265835583f15f6df4253bc117751b87d3a34"
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

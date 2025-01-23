class Cxgo < Formula
  desc "Transpiling C to Go"
  homepage "https://github.com/gotranspile/cxgo"
  url "https://github.com/gotranspile/cxgo/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "f3b4e7e1579c37e64618103bd82752e632d67653b686de9b513c47530169790f"
  license "MIT"
  head "https://github.com/gotranspile/cxgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2869f3397eb5b07e5e8977bba350a01b8094037b71dc8fefe81cefad2197fe68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2869f3397eb5b07e5e8977bba350a01b8094037b71dc8fefe81cefad2197fe68"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2869f3397eb5b07e5e8977bba350a01b8094037b71dc8fefe81cefad2197fe68"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1b9f53a63e688c9872604e6ed97f6713017aa1203cdbb4148a7c25047673b3b"
    sha256 cellar: :any_skip_relocation, ventura:       "a1b9f53a63e688c9872604e6ed97f6713017aa1203cdbb4148a7c25047673b3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ce6f29b644fa488aa3b595dd643197a89fa3e5e321fc5b91995921e81983266"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/cxgo"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      int main() {
        printf("Hello, World!");
        return 0;
      }
    C

    expected = <<~GO
      package main

      import (
      \t"github.com/gotranspile/cxgo/runtime/stdio"
      \t"os"
      )

      func main() {
      \tstdio.Printf("Hello, World!")
      \tos.Exit(0)
      }
    GO

    system bin/"cxgo", "file", testpath/"test.c"
    assert_equal expected, (testpath/"test.go").read

    assert_match version.to_s, shell_output("#{bin}/cxgo version")
  end
end

class Cxgo < Formula
  desc "Transpiling C to Go"
  homepage "https://github.com/gotranspile/cxgo"
  url "https://github.com/gotranspile/cxgo.git",
      tag:      "v0.3.3",
      revision: "187be2cefefdd74efe861994ea51c0d0c0cd3f38"
  license "MIT"
  head "https://github.com/gotranspile/cxgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e14d977150e9df2e2e8be57c78c6be177e50ad9e20eaa45c0c689eb73a3f716"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a1b8011d4e7108aa888e098a1306852822451c61805ec702df4e3f23d639c75"
    sha256 cellar: :any_skip_relocation, monterey:       "f44b29dacd917ac629d7ce1076b40d89db4674314a1202226e0b23a3a2922255"
    sha256 cellar: :any_skip_relocation, big_sur:        "33f9953758f537e1d3aea608faa49e78eac54b831eff806a0e16abdbf2c751e0"
    sha256 cellar: :any_skip_relocation, catalina:       "748ba73ec9d21111f3ce5ecb63f1afa86e06e904de76f30b66c6bd00a9505365"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b15fcae03d2d89b5b536a0fe9ea9d5d6d9a2ed56379998354263747389206282"
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

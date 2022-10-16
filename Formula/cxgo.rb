class Cxgo < Formula
  desc "Transpiling C to Go"
  homepage "https://github.com/gotranspile/cxgo"
  url "https://github.com/gotranspile/cxgo.git",
      tag:      "v0.3.7",
      revision: "cfc1ca865f59182eea902a45ce96b4cdda0f2b8c"
  license "MIT"
  head "https://github.com/gotranspile/cxgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "035b673ef60a34ff7530917b5900944270ceb7dd341b463651162479f4693f5d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c15447701a5ecb2d2a71146edaf4179dc263cf72736d379b8b092b456eb644fa"
    sha256 cellar: :any_skip_relocation, monterey:       "38ede1b76309edfa8133861ad5a6c2f7585312f738d351fc2c469ae171db7858"
    sha256 cellar: :any_skip_relocation, big_sur:        "b25a381fefe12281fd957c59d30b75118139caf7562dbb3f043485b78979d8e8"
    sha256 cellar: :any_skip_relocation, catalina:       "067789924d51c646ed958b36d7ee84efd98914b04c14098c3839a5fe316a641d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbda0baedff1788890b8afd6ceca3a52a3687be91172cf730f1b115f4442e7b9"
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

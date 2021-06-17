class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/v2.8.1.tar.gz"
  sha256 "54820f7120265745710f54246ea5cde0fbdd6a9024cec8147f34b3c1855bdcec"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "300e94a82d32dfac6955742ebd6b462e573e90cdaeaa58b034f812aa394726d5"
    sha256 cellar: :any_skip_relocation, big_sur:       "71c256c4cd679293b9b50c72f0180d2abc1fbec3cf2c00c16603c931166f1603"
    sha256 cellar: :any_skip_relocation, catalina:      "c51826135ed9073b83828d5bb3fc656db818da9a36b09e0ef8f3d9132b54decb"
    sha256 cellar: :any_skip_relocation, mojave:        "3b5a5c6b0c5fc821206567bd669129a047eea56aa9ad742695cb87ee4e173027"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.version=v#{version}", "./cmd/gosec"
  end

  test do
    (testpath/"test.go").write <<~EOS
      package main

      import "fmt"

      func main() {
          username := "admin"
          var password = "f62e5bcda4fae4f82370da0c6f20697b8f8447ef"

          fmt.Println("Doing something with: ", username, password)
      }
    EOS

    output = shell_output("#{bin}/gosec ./...", 1)
    assert_match "G101 (CWE-798)", output
    assert_match "Issues : \e[1;31m1\e[0m", output
  end
end

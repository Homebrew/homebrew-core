class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/v2.12.0.tar.gz"
  sha256 "8aa8f417ef0aa029595a6990984f5b9b750ab1988a8f895f514c612764b59da4"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "805ffe790a0fba9168c8e00c678e9ebcd88fef92a491a1278e807084b9264301"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7cae894417cedc864ae66e228173293d67704ea1fa47189d6ca0d1b3ebeba3e5"
    sha256 cellar: :any_skip_relocation, monterey:       "5f03546bdce5843d52d9d3478f0c27cfa8870ffdecfebf9690dc344dd7430a11"
    sha256 cellar: :any_skip_relocation, big_sur:        "47cb52e304ecfdbdb4544225c247133ec03223376cec59ce66d89a179ab6ba28"
    sha256 cellar: :any_skip_relocation, catalina:       "fe3641fd577521b61adf4e42c150d6a4e5ea8b592167e45eaecf76439b1c8477"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c50b26985752ef62a91329dade12a20e1fd1b316cd0d0d7babf2a028961aa7c"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/gosec"
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

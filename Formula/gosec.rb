class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/v2.9.2.tar.gz"
  sha256 "626cd3c2bef1eb3ea0838b3e9cd81a0db74fbd6a1557ee3c74add3fad24010f1"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a48448ed2ff9f0ce9b200ba74a71166a230edc46053fbeafff809272eacc3ab7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f227ae0bac91a3a9fcb61e922258d0c067db5b2a587aebcbddce89b3c3c75a82"
    sha256 cellar: :any_skip_relocation, monterey:       "ae603ec65a2ea0495b8d8e42254fe781792b9df9025302f6258dfefe2a87ce93"
    sha256 cellar: :any_skip_relocation, big_sur:        "53d7fd9ada9d73bf95509f3e46abcf7741fb4b3fb1477bc82781ac6b3ed3973a"
    sha256 cellar: :any_skip_relocation, catalina:       "33e1c75404c66564fb1b246280c3f18edf3a5e888bef3f0f75b95d3dff552f83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0551f5bb95276254edc301839446338ff3e789c026d388960a0cb44e7155415"
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

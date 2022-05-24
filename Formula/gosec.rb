class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/v2.11.0.tar.gz"
  sha256 "24805fc392be01bbdd01bd192acde2effa4aa3b669b2938e46bca892889141cc"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6545337d124c50ca122f10f9d44cd546fcea1fb26d1a712bb2884037335548f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef7ec18d830fed477413c62fcb2195d77283e77a4e96a96dcd79fec8a321dc11"
    sha256 cellar: :any_skip_relocation, monterey:       "63faceb6f282172e2f4483356ef22b087c79e554a789dc911ff0d56a5fa81e44"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c42f2b7a49a7579a664e23b7ec0fd2169ebbe15d3041590154557e1622dc1a9"
    sha256 cellar: :any_skip_relocation, catalina:       "0815b07b4315bc430e374a91329550cc45dce6c617ad93ee8a8192c1df924bcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "387b7b7a55d9cf05d8ba291636e1b34a40015d732ba4aa096b3a2e6160d93069"
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

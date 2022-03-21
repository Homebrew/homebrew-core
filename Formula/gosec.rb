class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/v2.11.0.tar.gz"
  sha256 "24805fc392be01bbdd01bd192acde2effa4aa3b669b2938e46bca892889141cc"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c0eed9e133f59b376b45ed1f24e7ac2500de5c6d34456b5fdfd76f7b6aa9e1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ac779ce6820a6d3e0296758920f67d5a0005f59dd873e606fc290b6cb15bef5"
    sha256 cellar: :any_skip_relocation, monterey:       "622ad0a63f5e7f8ec7c4c812472d146b844c5ff368eaec202d597da16e7bcf68"
    sha256 cellar: :any_skip_relocation, big_sur:        "102ee60b9fd4bb3e3e6053d827fa4aede193e900bf3c76d2754ee69e1ea8302e"
    sha256 cellar: :any_skip_relocation, catalina:       "98029151def94221f601b9949c5dea6628b22b2ba1e9021b3d9b500c691a69c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a4168d9cc2e6ce2845abe6a740a1d4fed0c6b39275a46f22a2f3b1524e435a3"
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

class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/v2.10.0.tar.gz"
  sha256 "a2cfd36884745693f7e6737922a6e3a9d60aeafe5dd24fcc398250ffa201ceda"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5eb8111c32174f40a06bd0a0a5122711cb3954cac7ba1727cd49797ee3b45be2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91ba7529e676811a49bf4b95621378c39857121fe43a32c13a0737106cdd07ef"
    sha256 cellar: :any_skip_relocation, monterey:       "69fa40e824a7f1afbf8aa2d0870def2ea2eac73960ecd6109f0ab9c3ef53369d"
    sha256 cellar: :any_skip_relocation, big_sur:        "872587368d314437087c1f718d8b98a5f24d6aebcd30121ea61aab80fa8d0798"
    sha256 cellar: :any_skip_relocation, catalina:       "1d20b1d345642466618121853d0b3649008eba10614e6624f8e121d779a80b74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e362eee9515d1b872da958402c5b854d08abdc07c9b82f99c118785e5cf411d"
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

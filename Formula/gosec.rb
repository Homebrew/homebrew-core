class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/v2.10.0.tar.gz"
  sha256 "a2cfd36884745693f7e6737922a6e3a9d60aeafe5dd24fcc398250ffa201ceda"
  license "Apache-2.0"
  revision 1
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2fa9316e064269e79316972384ca1f110ed9bf30f646711074d0b22d68fa0fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3594a846b67ae5f0b013b7e6bff7c7e06e0b766dec598ba0470fd2baac9e15aa"
    sha256 cellar: :any_skip_relocation, monterey:       "6ebe99c377916f5166000cf8fb1db42650c8bb795b70d99ae76284d433e7a5e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "9bff785102a123aa475401782ca7c3dc95c43d21a8a3e4273aa9c42b7b49b792"
    sha256 cellar: :any_skip_relocation, catalina:       "d0501acd240338fcc524cf5eb539d4df3f68aee7374d2e565f835af47b3b4d51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1bbfc2d4b42dd091db8e76e7208c4c7ae7b3aab19f762527a400ea44e9872fe"
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

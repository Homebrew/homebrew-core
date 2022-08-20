class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/v2.13.1.tar.gz"
  sha256 "72e107b5c1f71df8e8dedacbd3650a9c5d931bc8e8be1c7ead51ce379a6ab5ae"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7263ac64ed45e59b42b95a1052d95f38b3e98f5186b9329577916049fc5b46c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02aa35e2bd16f5e85e3257b48259ccf53829344060438834a4e42e6e0f099125"
    sha256 cellar: :any_skip_relocation, monterey:       "871dcaa32de597df41d664d8fcbb87ce833ae21b8679337fab991625414108c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b4f63a8d0f69f6d8c3e8d0adc672b17f5efffda166f9247573ae858dc4eec4f"
    sha256 cellar: :any_skip_relocation, catalina:       "e80b8093c60ba5f36ded3ed5cd6080d93fd5773c3d06b96cc0bd13d4dd785c2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be7aebe51090fae6776aabd3501a481ea9bea41b3c8b994e1bde34b0829b41f4"
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

class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/v2.7.0.tar.gz"
  sha256 "fd0b1ba1874cad93680c9e398af011560cd43b638c2b8d34850987a4cf984ba0"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8eaa54d014d924fa1ca807c25d7b2827023103582d7b269234f35a448787da64"
    sha256 cellar: :any_skip_relocation, big_sur:       "12d452f02f025f62136d866c00cdd54e0594e3ec1930d70f3aecd4960388273b"
    sha256 cellar: :any_skip_relocation, catalina:      "d6d5c69d310d0471950f4682193d27c4e59ef3b26acd185c01f9ab3cc7f78f92"
    sha256 cellar: :any_skip_relocation, mojave:        "7b07d7387e6477c1be027fd6f12eba5b3ac3f19b4fe5762cab07171aed40a514"
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
    assert_match "Issues: 1", output
  end
end

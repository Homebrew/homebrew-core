class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/v2.9.3.tar.gz"
  sha256 "391445dd905588016345c01982bfd7e9ede39dc57112b675c5fc965841ec55b9"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0984caec30c7528542ec7ab13ebb0340f9faaba567d14b6688c2161cfabcdf77"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f53a861e242018be6cfdc0db4674fff4b3ac9f5e6e11a7fe434b4fa28924f9f"
    sha256 cellar: :any_skip_relocation, monterey:       "ca0521f8a815f1f494e65bba51e7e7487058a0396c2746e4594353b3dd701cc8"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d8fde9385e477df7c0b3940d9fca87e7c6740ef5214a0d90a845a7993ca84e0"
    sha256 cellar: :any_skip_relocation, catalina:       "688fadb5fb26bc491fdfc5743e0a4e30db0edf658cedeee5912db8067f787d6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6e52caef44bec351e2b241d56df7417cc0cd403a92a0412d6bd39f1762022c3"
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

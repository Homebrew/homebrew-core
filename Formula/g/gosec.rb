class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/refs/tags/v2.21.4.tar.gz"
  sha256 "fe3d78c52383164906d3cca5b22e693e22a146a4b89a8f60438fdaa833e32b3f"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5571a78eebcc2894002a97d6a0c61aa1e07e982720df4c1dc5696afa96b12de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5571a78eebcc2894002a97d6a0c61aa1e07e982720df4c1dc5696afa96b12de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b5571a78eebcc2894002a97d6a0c61aa1e07e982720df4c1dc5696afa96b12de"
    sha256 cellar: :any_skip_relocation, sonoma:        "e74361f658185b11b73634ccb6c243da37dfef808d38a924f4bd4728ebec728b"
    sha256 cellar: :any_skip_relocation, ventura:       "e74361f658185b11b73634ccb6c243da37dfef808d38a924f4bd4728ebec728b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddb2653a49926b73033c002e1b3fd9ec25d0a97d6df7e3ddc002d72fe422cabb"
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

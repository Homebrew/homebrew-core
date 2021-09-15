class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/v2.8.1.tar.gz"
  sha256 "54820f7120265745710f54246ea5cde0fbdd6a9024cec8147f34b3c1855bdcec"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4452d763462f9558721289ee8c1d9fbba04e36fb2b2eb1c9bf8ac59edaf759d9"
    sha256 cellar: :any_skip_relocation, big_sur:       "54e7772a0413cc7ba0e45e3476ae51b7cb13b4b8232b52540a56a4eb9bb4059f"
    sha256 cellar: :any_skip_relocation, catalina:      "805fce42a1339373b7cda4ed947ab57f0808600f3f02ffcd59567df2877e1e3f"
    sha256 cellar: :any_skip_relocation, mojave:        "1c334b925541f89af00c3fe31194f67446dcf75beae2506713625e55376685c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0482159716aee50b31fc9e6327e41750a032089e4ac3087447b4c50d3812779e"
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

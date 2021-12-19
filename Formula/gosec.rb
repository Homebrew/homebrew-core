class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/v2.9.5.tar.gz"
  sha256 "7c6fd7e05e8ae8b8c8816616f61cf334f44e17dff0b3b1294daea0f04aa92f01"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1abb42c11452494d96d362d730a6940ad8e5928addbf539d4f37f19b30e8c88b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af14edb4cadc0ffabb08c954fd6e2deeab5c8fdb960afbc2957030342a5d125d"
    sha256 cellar: :any_skip_relocation, monterey:       "e50eb802df27f163de4ea235c3813baf84df3af4621f441c7f2c3450e3bebc0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "e37d5b497a3600de18c73ebec64caff0e5fcdd4a110a65aa3591d2226cb3b84c"
    sha256 cellar: :any_skip_relocation, catalina:       "54a41e0b7cf04640a2d6d7e6c4d0c4b6b5b500f7fff61bc3d073e9855bd7e351"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "059a54dea77916ae4d8fd5feb847380e7013747d1240d0883c85bcdac6ba0a56"
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

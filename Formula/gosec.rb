class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/v2.9.5.tar.gz"
  sha256 "7c6fd7e05e8ae8b8c8816616f61cf334f44e17dff0b3b1294daea0f04aa92f01"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f997bc8e076b88bc527d47e23b9376048f59b671b6af5eecac1201f2f7037221"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa5bd5c964d0cd5a8cad1335e85da29dbd1a6e5d434aadc1a025a64185e7685e"
    sha256 cellar: :any_skip_relocation, monterey:       "0e3ddec7a468a68e8ba4a75dfa9e43833dd35bbfa9f51b4f1ed1d0ed5987e641"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ca1524597f069851eec405619ff9bfe04b8d4c5ee053af1dbb049d562c864c1"
    sha256 cellar: :any_skip_relocation, catalina:       "89c69dc24c15c1764fbd0336b9aff91eeb3efa6da36a617ee0df055ef81989fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5112877879247455842de72de02ac63214dc8b472387b4f85d3c3a460d2d081"
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

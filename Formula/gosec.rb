class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/v2.16.0.tar.gz"
  sha256 "c483228b0f4bf029c321de46c702bca7a1c176ffc8b901f404a51a499d16d0b2"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8620d0bbe7b75c5a5e4f521294457d82d975071166f872fa8952d0c25c14e6e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8620d0bbe7b75c5a5e4f521294457d82d975071166f872fa8952d0c25c14e6e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8620d0bbe7b75c5a5e4f521294457d82d975071166f872fa8952d0c25c14e6e9"
    sha256 cellar: :any_skip_relocation, ventura:        "f2a0c745cfd9011d61de7d9f1869eb502f31da1ec94878e785b359e708209e07"
    sha256 cellar: :any_skip_relocation, monterey:       "f2a0c745cfd9011d61de7d9f1869eb502f31da1ec94878e785b359e708209e07"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2a0c745cfd9011d61de7d9f1869eb502f31da1ec94878e785b359e708209e07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ccc7adec86c22638dcf29a49b761490d546ad8991e1bf36b1ddf3e2f1b0e9af"
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

class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/v2.15.0.tar.gz"
  sha256 "f6502b042bf24f9748538c796c32d6f90e0d20c419a3959858b6f454d3d90b3d"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa9415b009670bc8bcab052823ff04ed96c1d440b7bc60111e3313b1f559920e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c5768454f9a0722a18086585f7ff971632494ac93675e1f469fd72595caf615"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8e8372033c5209ec71b5807349f0ac45fa8cd5e02fb93357569aaf377e34813"
    sha256 cellar: :any_skip_relocation, ventura:        "f631af7a92fd806521a53f8820c21974af9cc76ce1f8ec5acd857fe77c0c41a4"
    sha256 cellar: :any_skip_relocation, monterey:       "fb686fe2ef919534f5f0b2b8c5622f767df02d7a71cb9729ac5d1902160b89f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7fa0ab370e2295b43e7a2c4c2dc6c453486f63888861c42497217e26632cc9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e9739d9bb15c7936b8ba9b62bbbc7c565dd01a4027ac54aadf1e336bc98e9e4"
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

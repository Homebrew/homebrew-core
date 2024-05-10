class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/refs/tags/v2.19.0.tar.gz"
  sha256 "5c781c7c3df89d0edf11b45bea9c1ea966c68521316d68e5e49ad895c2278f69"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c6f5da4e3126c8bfc296acb58df5ca0e05b711f724501c0494bb488343a4c1eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb5fa7c79734e23962a43a6c490dde69c19fe74023e480b9f6eafa609d3bd774"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c5ac4ae17425663d803b873a0d85716e5becc94dfdd408a6d838c03279f4fda"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e26ca2bbeaccab215bc320adaad8124dcaaf40468ba031bcedae956c56ba997"
    sha256 cellar: :any_skip_relocation, ventura:        "261c071ab69f0f5963891e48f864e0b1589a125dc604b543c737eb0b578dce6c"
    sha256 cellar: :any_skip_relocation, monterey:       "0e8fe3597ea1bacd9b0b9b07f4a98bf84b46c08b1f4d6de7c579a5b6851e92cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c0e45b6a9db34e024326a832f45c9d20fdb98b2c0c8b8b5c9dab6094d220248"
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

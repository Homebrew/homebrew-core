class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/v2.6.1.tar.gz"
  sha256 "2b86e4b9ecaf5c8ef61949c4091d43cf7f20e96fd411d08d72189ec20038a7c8"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f18ea227cfcaa1dbce64ee3442fc73fd216e2c257a4f7ea68eef08d201b28b7" => :big_sur
    sha256 "6cdad6416afab7b8957194675cb475bbd3752116dca71644e2bf454b4712c342" => :arm64_big_sur
    sha256 "ece08231a00e65991ef7ee0dee8b89fb94bd8bb0fe46f3bc62cda1ecb8a6671a" => :catalina
    sha256 "b98b577330645df9104cbf2c7d88c0c38fbc75ddbc68b19bd8874d832eb09beb" => :mojave
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

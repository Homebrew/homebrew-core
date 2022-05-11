class GoBoring < Formula
  desc "Go programming language with BoringCrypto"
  homepage "https://go.googlesource.com/go/+/dev.boringcrypto/README.boringcrypto.md"
  url "https://go-boringcrypto.storage.googleapis.com/go1.18.2b7.src.tar.gz"
  version "1.18.2b7"
  sha256 "3c3ce00cd39cdd2ae9afddd7581c6f8b14f8e96e2bb56b9cb4fec8ff02db63b0"
  license "BSD-3-Clause"

  livecheck do
    url "https://go-boringcrypto.storage.googleapis.com/"
    regex(/>go[._-]?(\d+(?:\.\d+)+b\d+)[._-]src\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "d405ac2add5812b6b6742dda0a5064612af67a6c730ef82facf92b28a6017c97"
    sha256 arm64_big_sur:  "a7e57b12658af9fb8c074a8a5874b0d3aca146e67c6418d9888fa08711937941"
    sha256 monterey:       "22c8ff691719a951a1995e7f8a81cd06ff872f19281990a42ecce28f711800ef"
    sha256 big_sur:        "08429c8280ab4e30d7ae3c3e5c6472d386e0696951121881e199e00506a20f9b"
    sha256 catalina:       "a3cebf591ec7460774695fee9e8cc504991d715a18b90e82812a27cc2b232518"
    sha256 x86_64_linux:   "bcffddb759274f558f9495509c60c375e27041082f1c11eeeb0e21fd2a537ea3"
  end

  keg_only "it conflicts with the Go formula"

  depends_on "go" => :build

  def install
    ENV["GOROOT_BOOTSTRAP"] = Formula["go"].opt_libexec

    cd "src" do
      ENV["GOROOT_FINAL"] = libexec
      system "./make.bash", "--no-clean"
    end

    (buildpath/"pkg/obj").rmtree
    libexec.install Dir["*"]
    bin.install_symlink Dir[libexec/"bin/go*"]

    system bin/"go", "install", "-race", "std"

    # Remove useless files.
    # Breaks patchelf because folder contains weird debug/test files
    Dir.glob(libexec/"**/testdata").each { |testdata| rm_rf testdata }
  end

  test do
    (testpath/"hello.go").write <<~EOS
      package main

      import (
          "fmt"
          _ "crypto/tls/fipsonly"
      )

      func main() {
          fmt.Println("Hello World")
      }
    EOS
    # Run go fmt check for no errors then run the program.
    # This is a a bare minimum of go working as it uses fmt, build, and run.
    system bin/"go", "fmt", "hello.go"
    assert_equal "Hello World\n", shell_output("#{bin}/go run hello.go")

    ENV["GOOS"] = "freebsd"
    ENV["GOARCH"] = "amd64"
    system bin/"go", "build", "hello.go"
  end
end

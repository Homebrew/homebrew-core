class GoBoring < Formula
  desc "Go programming language with BoringCrypto"
  homepage "https://go.googlesource.com/go/+/dev.boringcrypto/README.boringcrypto.md"
  url "https://go-boringcrypto.storage.googleapis.com/go1.17.5b7.src.tar.gz"
  version "1.17.5b7"
  sha256 "4c508aecce1b56e34a4e32605086994606c72010b7caedce7681c1019781c93e"
  license "BSD-3-Clause"

  livecheck do
    url "https://go-boringcrypto.storage.googleapis.com/"
    regex(/>go[._-]?(\d+(?:\.\d+)+b\d+)[._-]src\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "878c538076d278bd37c9b66298d205448c4c15bf9fd0f46b1c35b5f81d8f7afd"
    sha256 arm64_big_sur:  "8508b04fbdce64cc54f33f6a613519c9bab7eb46616340044bd152bd7b8e6b04"
    sha256 monterey:       "616244e82d0d1bd761fc2f40348becc886c2051b39e44a89462756059bb2605d"
    sha256 big_sur:        "1e9b951373144b74fafa06107d624aefd5149f9539393acc5456688d427b9460"
    sha256 catalina:       "6880e038174b755d3fb8e01591406421b1b1cd2f02bf6d076c90cf2019de5dd3"
    sha256 x86_64_linux:   "3239404e57e41ade9a6ee345b7f7623d141b8c58577808f0889a862bf703f912"
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

class GoBoring < Formula
  desc "Go programming language with BoringCrypto"
  homepage "https://go.googlesource.com/go/+/dev.boringcrypto/README.boringcrypto.md"
  url "https://go-boringcrypto.storage.googleapis.com/go1.16.7b7.src.tar.gz"
  version "1.16.7b7"
  sha256 "f65503abf459ba1d2f77d4d023fcebd19c62e7c34d3ffd0f1aebb598ffa153d9"
  license "BSD-3-Clause"

  livecheck do
    url "https://go-boringcrypto.storage.googleapis.com/"
    regex(/>go[._-]?(\d+(?:\.\d+)+b\d+)[._-]src\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "af50e7495fa248016283b789a1a8cb01cb3ce1242c76ec18b42e4af11502040a"
    sha256 big_sur:       "314d56e3de0b807847d3ddddefb467782880de0dc127a8c4df9ba67ca0765ada"
    sha256 catalina:      "034698fbe3a7292f4c2ce3eb7d6b9ddb92ee20cf23a923cd82fe7010dc030ff9"
    sha256 mojave:        "3caae2cc1e6a8ea6bdfc6fe2f5da14652f7f9493d3b1f3170d7bc9f72b6936d7"
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

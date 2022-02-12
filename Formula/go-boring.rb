class GoBoring < Formula
  desc "Go programming language with BoringCrypto"
  homepage "https://go.googlesource.com/go/+/dev.boringcrypto/README.boringcrypto.md"
  url "https://go-boringcrypto.storage.googleapis.com/go1.17.7b7.src.tar.gz"
  version "1.17.7b7"
  sha256 "eff84edf4f676c691ac21747277e15777789be32dcaa53a0779737b280351453"
  license "BSD-3-Clause"

  livecheck do
    url "https://go-boringcrypto.storage.googleapis.com/"
    regex(/>go[._-]?(\d+(?:\.\d+)+b\d+)[._-]src\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "e60cc45d9c228cb27d3efd6fbdc429234ff7816432000c5925dcc5e132dfdbd3"
    sha256 arm64_big_sur:  "112c2326f18885b6b12062d2cc6d91d446e492a5f8b350d22da5e8de0f8ea241"
    sha256 monterey:       "1fcdf7072c647df018f9707011bbafa481ced55963ffff2a6b6360c0be1088ca"
    sha256 big_sur:        "825f2280b5b8915ceb809f9e4b021e7571b87084f82824e517aa08da842bce7c"
    sha256 catalina:       "5fde892e5370cd328cdcc3aa1c58a1593c6dc766ee85af50e4fbacf54894fd84"
    sha256 x86_64_linux:   "70278da72c6707eb1a2cd4684a0411f891edaa44d9528eab3c2d77facad8f0b9"
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

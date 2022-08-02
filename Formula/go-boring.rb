class GoBoring < Formula
  desc "Go programming language with BoringCrypto"
  homepage "https://go.googlesource.com/go/+/dev.boringcrypto/README.boringcrypto.md"
  url "https://go-boringcrypto.storage.googleapis.com/go1.18.5b7.src.tar.gz"
  version "1.18.5b7"
  sha256 "75f5021bd9b61f837fdd516cc4ec51556c519c7155a2e99ecfb4efeca8655aa7"
  license "BSD-3-Clause"

  livecheck do
    url "https://go-boringcrypto.storage.googleapis.com/"
    regex(/>go[._-]?(\d+(?:\.\d+)+b\d+)[._-]src\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "2760db2d1608418101c2b800081436d4a144d580a40e286ba0d5da5b309a030e"
    sha256 arm64_big_sur:  "fe51a4028a64edc1100a7784ec39d3875fc73e0989fb406cac7dd17cd1aa83b7"
    sha256 monterey:       "7395303f38b7aa7cde2859014c0f94dc2fa70deba90c7591343a54def8ad4cb7"
    sha256 big_sur:        "115043b9e4ac680b7fdf716d047e7485093ce6cbbc7e351eedbdde78d8526196"
    sha256 catalina:       "d6bdd3ced49a8e08dc251f6e2ce5088a0b7237f54d3736c6c4aaaa92974f826b"
    sha256 x86_64_linux:   "a9d078a7f30435e0fc1b124e405d2020a0cf669ae0ef1834d63d3638747f500c"
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

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
    sha256 arm64_monterey: "561d62051e0500e291f68b4d6eca5da30b15c11b69bf00b2b4adabf29be366ac"
    sha256 arm64_big_sur:  "4a197f9643c8bd09f288b95f6d16f425f68983fd640a3d55298b6e305ef6482d"
    sha256 monterey:       "f9fce63981a3328a0866d612b8d10045ef6e93352aa52653896fa25d916cb46a"
    sha256 big_sur:        "3073f675a239794f5d2f86088df5974329907d639f89bde80393e64a50fb6834"
    sha256 catalina:       "be4557357b38a0db88515c7ee7fb399d928890a4257ba94896adbba95700078b"
    sha256 x86_64_linux:   "6d7edd4385a57dc925944f00a3d30e447bfd174f0d6c6ca8ff55758d7974b3b8"
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

class GoBoring < Formula
  desc "Go programming language with BoringCrypto"
  homepage "https://go.googlesource.com/go/+/dev.boringcrypto/README.boringcrypto.md"
  url "https://go-boringcrypto.storage.googleapis.com/go1.18b7.src.tar.gz"
  version "1.18b7"
  sha256 "6028ffee59903934a3182d45ee3e0c1c9f47fb98f05d9bbb2fabb4771db60792"
  license "BSD-3-Clause"

  livecheck do
    url "https://go-boringcrypto.storage.googleapis.com/"
    regex(/>go[._-]?(\d+(?:\.\d+)+b\d+)[._-]src\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "01f2c7d230d08c6d8f7d6f45852010cbe7376a778869bff12d24f561c7622281"
    sha256 arm64_big_sur:  "4bf7da5d7f011996a201f2cd0b30ec6ea9bd808ce7cf318b329cb90ba9834564"
    sha256 monterey:       "381f66bdc6e8aa9c0cc8acf523d1bcaf5a68d11f8e6a0244a9afc3ffdc1b6ebb"
    sha256 big_sur:        "176fc320abf025f87ed7b6d6892ce732a100f96be1e70dc87a8971501105d946"
    sha256 catalina:       "37218794f2f8793fc08c055a21257d1eff0b3620f218b58fd342f976aa5d3df8"
    sha256 x86_64_linux:   "98d778304ddcd352d489ce6baeff9fd7da44706d87b9d97caccd9b7aeb60045d"
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

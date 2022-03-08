class GoBoring < Formula
  desc "Go programming language with BoringCrypto"
  homepage "https://go.googlesource.com/go/+/dev.boringcrypto/README.boringcrypto.md"
  url "https://go-boringcrypto.storage.googleapis.com/go1.17.8b7.src.tar.gz"
  version "1.17.8b7"
  sha256 "e42ac342c315d33c47434299a24f33137e7099f278ee6669404c4d7e49e17bcf"
  license "BSD-3-Clause"

  livecheck do
    url "https://go-boringcrypto.storage.googleapis.com/"
    regex(/>go[._-]?(\d+(?:\.\d+)+b\d+)[._-]src\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "4de553db29a5b32f1ddc2e4053a80e790ff14ff2e695d12bece712ccb6187df0"
    sha256 arm64_big_sur:  "63a994467543d5093854c6411ee1468c3d943d04ed905bb2dcb30743e2a725a6"
    sha256 monterey:       "c86b010202fb30ba6aae2cb6f7afc696f8e5c17a4c5ed54f7c08106679a456c9"
    sha256 big_sur:        "54c31aff5809f3d658e20f342826fd5f27c45ada2a246726d97177ac369eef65"
    sha256 catalina:       "6abded057bd85d4f82bc9be18c768dc9e9a92f797216fc1c29509fba1e6f4a89"
    sha256 x86_64_linux:   "0bff363b5e8cdfdc59fd3da75740d4e1587a8a6c938383cbeeb4872c964bbb44"
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

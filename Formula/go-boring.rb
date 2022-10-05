class GoBoring < Formula
  desc "Go programming language with BoringCrypto"
  homepage "https://go.googlesource.com/go/+/dev.boringcrypto/README.boringcrypto.md"
  url "https://go-boringcrypto.storage.googleapis.com/go1.18.7b7.src.tar.gz"
  version "1.18.7b7"
  sha256 "c62ba13f792f64f31381d34a7d6b14aec0b04363eb67085b999d1d6e51a94136"
  license "BSD-3-Clause"

  livecheck do
    url "https://go-boringcrypto.storage.googleapis.com/"
    regex(/>go[._-]?(\d+(?:\.\d+)+b\d+)[._-]src\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "13772c4b8b3cdbcbe3ed074bc66099e5b4ea1bf3fa77332fec23f5bc4894963b"
    sha256 arm64_big_sur:  "4ed51e035df2b9a8bc2eef261f9fbd6621ef862b2c2b9f34a69869ec7c68e200"
    sha256 monterey:       "48c4ebf50e039e5cbccda68cfbd2779f9741c2b9e134e0951baee7e4149f0b8d"
    sha256 big_sur:        "c1924593620266d4dd47dba3384a9975fc673d611c5240fb5963ac1a4d13efec"
    sha256 catalina:       "546b6845f2138a10a3cbd3d9019008b22a8383590e3f816cd3dea17e557f0dfe"
    sha256 x86_64_linux:   "64ed81feb92e5459423e3563be6a4808a4c0868673d2febc12364857845d1338"
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

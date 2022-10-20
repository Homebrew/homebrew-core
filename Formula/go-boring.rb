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
    sha256 arm64_monterey: "d25abecbf843ecd771e26a250527de2c87ee59e5cb987e5ae5b53546274231c0"
    sha256 arm64_big_sur:  "f7fd2be2533b43908580c764c406f0543b651c13c570dedfa654c8f1a2c65797"
    sha256 monterey:       "266bd6b555ee956216832b6e7f0e696b0c95ff5d55f76a0eef092aae9546ca79"
    sha256 big_sur:        "a726ee235ec26beb9cc1cbfe2ac61062e032ebaf405b2c0fd9c8f1373b24c984"
    sha256 catalina:       "7c9d435828283bad5df688f512786a0b6ecea4ffa78457348b3e46773f3eeef6"
    sha256 x86_64_linux:   "d750931274826bbb2e87d5dc81b8dcdec79a18db2975b9b6f5bda483020a8984"
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

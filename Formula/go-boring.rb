class GoBoring < Formula
  desc "Go programming language with BoringCrypto"
  homepage "https://go.googlesource.com/go/+/dev.boringcrypto/README.boringcrypto.md"
  url "https://go-boringcrypto.storage.googleapis.com/go1.18.6b7.src.tar.gz"
  version "1.18.6b7"
  sha256 "0afc7b1edb8b7570ba05bc30b112804280b1cc5750e1a3dc8500be5c8b8ba06f"
  license "BSD-3-Clause"

  livecheck do
    url "https://go-boringcrypto.storage.googleapis.com/"
    regex(/>go[._-]?(\d+(?:\.\d+)+b\d+)[._-]src\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "ef02bb78d37c3ca0b430a1ba59c65a2f0edeeae192ffe9fadcba93dff33ba3e3"
    sha256 arm64_big_sur:  "49fd99fa1ea1c88208ef36a875eb79e439a9b3740d9ff9b85157cecdf25d5648"
    sha256 monterey:       "bcf4e130e9518f0d727c9d9c6d9147f8ce01f5344d6a04d50d457496481cf27c"
    sha256 big_sur:        "e9a43b5fe55542f8b27612d680c3deaa918a9f0c7c16a0e26a4346de017c0c14"
    sha256 catalina:       "d75f427783b81104311ff2287654a99a46405b4f1e7e195011b8b83bb9bb81f2"
    sha256 x86_64_linux:   "67c52f355b89832756b01754f4e017736580716379ecbdf1c86d2a72152a58d1"
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

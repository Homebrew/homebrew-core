class GoBoring < Formula
  desc "Go programming language with BoringCrypto"
  homepage "https://go.googlesource.com/go/+/dev.boringcrypto/README.boringcrypto.md"
  url "https://go-boringcrypto.storage.googleapis.com/go1.17.3b7.src.tar.gz"
  version "1.17.3b7"
  sha256 "858595a95faf4c730ebe3d40ecba1705b79f7bc2a996fd044cb30da8d9c57534"
  license "BSD-3-Clause"

  livecheck do
    url "https://go-boringcrypto.storage.googleapis.com/"
    regex(/>go[._-]?(\d+(?:\.\d+)+b\d+)[._-]src\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "b262016974c28b906f75239c313494d3ea7cd0c2f202ca554ba0aeee47e7f2bc"
    sha256 arm64_big_sur:  "7ccf0ff61cdb126e916abdad7fe87f13bb52a544eac1e494550c13fd575ebec5"
    sha256 monterey:       "2d06bbb538254edb58747203f5f1fab20bff49190c7e04571eeaf478ee7bf866"
    sha256 big_sur:        "044c3e87f700e96ed9143c809581dcc4cac30c3ecf9572ba348ed96d71e78261"
    sha256 catalina:       "21726a7bbbb2747780d45765ae4ccf8730585273b509fd34ed93980e48fdb8b7"
    sha256 x86_64_linux:   "839da7cc8a465b216f8b09acefca1bc5a8d092806ad4c612be6975b737a38e11"
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

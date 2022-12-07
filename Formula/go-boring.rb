class GoBoring < Formula
  desc "Go programming language with BoringCrypto"
  homepage "https://go.googlesource.com/go/+/dev.boringcrypto/README.boringcrypto.md"
  url "https://go-boringcrypto.storage.googleapis.com/go1.18.9b7.src.tar.gz"
  version "1.18.9b7"
  sha256 "45b1ed1d3f63d1fa86c6f26329f11912c1dbfb1fa4fd39cf0eabc84e29f86cd7"
  license "BSD-3-Clause"

  livecheck do
    url "https://go-boringcrypto.storage.googleapis.com/"
    regex(/>go[._-]?(\d+(?:\.\d+)+b\d+)[._-]src\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "c9af52582c8709a3d3877d66dcc58cd6ba19011271129aace57d9d3016b38a7f"
    sha256 arm64_monterey: "71631625a7bbe31a795277e3ddba94da2a951d8c2a0b9e6ab8fa8481220fa6d9"
    sha256 arm64_big_sur:  "75cf8f48d21988a086e70987b75ad90fe40943cb39eead2498747a3c3470b9a0"
    sha256 ventura:        "9f54d8ea31738624fe075779545eb74a698f3ac23b221cb2195fc26432d7281b"
    sha256 monterey:       "8b2640416a29867198a610b6bd1aa96736752e1332ec276aa65e6f2ce806bda0"
    sha256 big_sur:        "38b491bedc6e5bf9d5c2a15c64c9a81f437ac61289ac6dddd235b45047d402af"
    sha256 catalina:       "19a5fe46c60092b1602a921984b66d7973576b343239a20395ad98c9a2121e0d"
    sha256 x86_64_linux:   "d6c91d6f5df9f6bc9db0f738734c75bd401a42a96b9be1f75e226a1b7d27f951"
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

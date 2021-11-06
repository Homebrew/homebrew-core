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
    sha256 arm64_monterey: "4440be070a04b1ff4226d0701002992e570b031d50fa91c9f7ac4de60214e283"
    sha256 arm64_big_sur:  "431f5814fb741c9fdaaaefa9d51cafb71a16ded3fb38b964d948ca89cdff0b78"
    sha256 monterey:       "3397560dbf013abc0d91a118c3821d558114ca1a5598f7dec342da1146267d4c"
    sha256 big_sur:        "7fb92e16334c75b0233b46e028c37e437b5cc11033b1bd7a462667625151887b"
    sha256 catalina:       "6661c22f8bb5da3bad3ea8cca66a8b50d27d676ec0718983d0b3feff29b2617e"
    sha256 mojave:         "6b9dc0eea391272af97eeeb480927648fb8e9e41645bbfbb43f63bcc0e8bea0e"
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

class GoBoring < Formula
  desc "Go programming language with BoringCrypto"
  homepage "https://go.googlesource.com/go/+/dev.boringcrypto/README.boringcrypto.md"
  url "https://go-boringcrypto.storage.googleapis.com/go1.18.3b7.src.tar.gz"
  version "1.18.3b7"
  sha256 "d8123121c491569c698ef713001a2193f13d9a8111a1ba7b2b0d4a2e9bf863db"
  license "BSD-3-Clause"

  livecheck do
    url "https://go-boringcrypto.storage.googleapis.com/"
    regex(/>go[._-]?(\d+(?:\.\d+)+b\d+)[._-]src\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "8a0155c97e3a1f1c7d258244f817d69fca9dd328b0a60c84898aa4fc0892bbd3"
    sha256 arm64_big_sur:  "336c4878faa3063c3d0d612e80269e0d03b437fcd75eaf5ad710f0cf0fe71907"
    sha256 monterey:       "648b1380431dd8f55087394e904d4f150f8239a668c79aca34e9fd9a7909eaf6"
    sha256 big_sur:        "79c91e19a59cb115518b0bd6869692ccdda56d505834c6d72af1a610af0d13e4"
    sha256 catalina:       "f9644504dae0d7d89cbfef6775a77274b1a0c1a893b8bec3244e8bb8b5a71da6"
    sha256 x86_64_linux:   "e4e2b529091cca4b83e388bf931409435b660cbbd34d6cbcba35d57298ef8b5b"
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

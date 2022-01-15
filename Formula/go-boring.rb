class GoBoring < Formula
  desc "Go programming language with BoringCrypto"
  homepage "https://go.googlesource.com/go/+/dev.boringcrypto/README.boringcrypto.md"
  url "https://go-boringcrypto.storage.googleapis.com/go1.17.6b7.src.tar.gz"
  version "1.17.6b7"
  sha256 "5178f595dea6d618f7cdf6b9e2346a1a28430b4d547996b766fcd5b34379ca2f"
  license "BSD-3-Clause"

  livecheck do
    url "https://go-boringcrypto.storage.googleapis.com/"
    regex(/>go[._-]?(\d+(?:\.\d+)+b\d+)[._-]src\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "13f88ad90255a7212d4dafb8acf00a8b3124e8d39eaf034eb718fb24e768f002"
    sha256 arm64_big_sur:  "ba3cda747290a19bb6377d6827e43307ed0363a7805a6e0602f5e758c76365df"
    sha256 monterey:       "2f20159cd307fb522bed362d03ce93bcaffdd9bc298065c460fb488e15e81278"
    sha256 big_sur:        "46b1f795305ee8956d3ee2cf6c024edc1588eec2bc1ecea75c371aa71870298d"
    sha256 catalina:       "f077732de4e7bda757d569df4103781b46209c7a7c0549c903d0069d76992266"
    sha256 x86_64_linux:   "5318247d1c923b23ba2e84b68d1ff8ed93260760e6f11505d6f0705359de36c8"
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

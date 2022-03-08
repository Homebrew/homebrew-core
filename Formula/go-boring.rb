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
    sha256 arm64_monterey: "0992d27043050890c51f91ea0d053a9979372599eb97102ce5df73a4ef7b9bd9"
    sha256 arm64_big_sur:  "867089c22223091956b419130dd52f13783bb6a261c9245e5fba0417551b5dc8"
    sha256 monterey:       "b2b7b18974cf7a41c4cc4063db493e0c6e1fcdd9ff791ac7becdddc7777e7cd3"
    sha256 big_sur:        "623d7a3fc706b41f10c9225e80d7d1f00c763c0748b5734dd618d4c2885ff363"
    sha256 catalina:       "ab721b770c9486ab05d242a61012e21212406bc485372ba22aa318b8d4c4830c"
    sha256 x86_64_linux:   "916466fa44beb8a4a12f5b618cdbdc8d278629d9b753c377b1002e8d75460730"
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

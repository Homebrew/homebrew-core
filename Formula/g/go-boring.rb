class GoBoring < Formula
  desc "Go programming language with BoringCrypto"
  homepage "https://go.googlesource.com/go/+/dev.boringcrypto/README.boringcrypto.md"
  url "https://go-boringcrypto.storage.googleapis.com/go1.18.10b7.src.tar.gz"
  version "1.18.10b7"
  sha256 "4ced930d738cb30f4c4b28b7281d1e2e397eda2353b4c8f7c6de82ef589acc0b"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sequoia:  "d3a8bebf95e0be877fae27cbe73a5619ead13a2a1635c7a38c180646cc6c5c2f"
    sha256 arm64_sonoma:   "a10ce7882dadd6ae0a965a5c8e5bff377f790d57f2ca2fa6b2f92c1dc1b2402d"
    sha256 arm64_ventura:  "df09a9ebf2f79a2066d339e217915cd783ea68ec7e61e25ee70faa4ca9ac7069"
    sha256 arm64_monterey: "56c292eaeabc94b48d5fde63cad4fe76af0c00d8842f7c1402a095ba6a14e93c"
    sha256 arm64_big_sur:  "26ae57114f36d0869b799f80308b4c52e1f9f801b94a99e4e7b5a32e8b5378c6"
    sha256 sonoma:         "71eaa2414190592052fd612d014cea86b1e46236ef5cb56b82f47becca2eb16f"
    sha256 ventura:        "aedd219222922535e42eecdd299dfd43bb760ff1ef3de485b3c113b994bf42c0"
    sha256 monterey:       "f0ee781456b7ad5fc6dd663d65f92d0355aad571f35addd2c8462c2e26f872c8"
    sha256 big_sur:        "79dff7b31871e6a09296de52c02b465d744c290d3428b8f5f9e0fe39d5d54347"
    sha256 x86_64_linux:   "d1474e5f3479f3feecda8602f5c4742db69999381e2d6539c60a01b337f5193d"
  end

  keg_only "it conflicts with the Go formula"

  # From the homepage:
  # This branch is no more. GOEXPERIMENT=boringcrypto on the standard branch does the job now.
  disable! date: "2025-07-01", because: :unmaintained

  depends_on "go" => :build

  def install
    ENV["GOROOT_BOOTSTRAP"] = Formula["go"].opt_libexec

    cd "src" do
      ENV["GOROOT_FINAL"] = libexec
      system "./make.bash", "--no-clean"
    end

    rm_r(buildpath/"pkg/obj")
    libexec.install Dir["*"]
    bin.install_symlink Dir[libexec/"bin/go*"]

    system bin/"go", "install", "-race", "std"

    # Remove useless files.
    # Breaks patchelf because folder contains weird debug/test files
    Dir.glob(libexec/"**/testdata").each { |testdata| rm_r(testdata) }
  end

  test do
    (testpath/"hello.go").write <<~GO
      package main

      import (
          "fmt"
          _ "crypto/tls/fipsonly"
      )

      func main() {
          fmt.Println("Hello World")
      }
    GO
    # Run go fmt check for no errors then run the program.
    # This is a a bare minimum of go working as it uses fmt, build, and run.
    system bin/"go", "fmt", "hello.go"
    assert_equal "Hello World\n", shell_output("#{bin}/go run hello.go")

    ENV["GOOS"] = "freebsd"
    ENV["GOARCH"] = "amd64"
    system bin/"go", "build", "hello.go"
  end
end

class Go < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://golang.org"
  url "https://golang.org/dl/go1.16.6.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.16.6.src.tar.gz"
  sha256 "a3a5d4bc401b51db065e4f93b523347a4d343ae0c0b08a65c3423b05a138037d"
  license "BSD-3-Clause"
  head "https://go.googlesource.com/go.git"

  livecheck do
    url "https://golang.org/dl/"
    regex(/href=.*?go[._-]?v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "af21bd9994caca9ab8279caea54a3aa3385357638c5e57356a6d670e217d4a8a"
    sha256 big_sur:       "91fded3b19303d0438ae8844c962c996d05c13d6e4d9407564142f9f2d3d8c78"
    sha256 catalina:      "71e0325bfb484880a680f253ef83e5b4ba2d8321bfd7a7ae8043178b0e5484ec"
    sha256 mojave:        "707d70b5d6315e4163096f9eae1a8c9509c967da68a4826233c9f1362be48dbf"
    sha256 x86_64_linux:  "628b09d4f733727a633440710d89bbf359552adad4281643bf9a4d56311133ce"
  end

  # Don't update this unless this version cannot bootstrap the new version.
  resource "gobootstrap" do
    on_macos do
      if Hardware::CPU.arm?
        url "https://storage.googleapis.com/golang/go1.16.darwin-arm64.tar.gz"
        version "1.16"
        sha256 "4dac57c00168d30bbd02d95131d5de9ca88e04f2c5a29a404576f30ae9b54810"
      else
        url "https://storage.googleapis.com/golang/go1.16.darwin-amd64.tar.gz"
        version "1.16"
        sha256 "6000a9522975d116bf76044967d7e69e04e982e9625330d9a539a8b45395f9a8"
      end
    end

    on_linux do
      url "https://storage.googleapis.com/golang/go1.16.linux-amd64.tar.gz"
      version "1.16"
      sha256 "013a489ebb3e24ef3d915abe5b94c3286c070dfe0818d5bca8108f1d6e8440d2"
    end
  end

  def install
    (buildpath/"gobootstrap").install resource("gobootstrap")
    ENV["GOROOT_BOOTSTRAP"] = buildpath/"gobootstrap"

    cd "src" do
      ENV["GOROOT_FINAL"] = libexec
      system "./make.bash", "--no-clean"
    end

    (buildpath/"pkg/obj").rmtree
    rm_rf "gobootstrap" # Bootstrap not required beyond compile.
    libexec.install Dir["*"]
    bin.install_symlink Dir[libexec/"bin/go*"]

    system bin/"go", "install", "-race", "std"

    # Remove useless files.
    # Breaks patchelf because folder contains weird debug/test files
    rm_rf Dir[libexec/"src/debug/elf/testdata"]
    # Binaries built for an incompatible architecture
    rm_rf Dir[libexec/"src/runtime/pprof/testdata"]
  end

  test do
    (testpath/"hello.go").write <<~EOS
      package main

      import "fmt"

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

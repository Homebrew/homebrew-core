class Go < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://golang.org"
  url "https://golang.org/dl/go1.17.1.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.17.1.src.tar.gz"
  sha256 "49dc08339770acd5613312db8c141eaf61779995577b89d93b541ef83067e5b1"
  license "BSD-3-Clause"
  head "https://go.googlesource.com/go.git"

  livecheck do
    url "https://golang.org/dl/"
    regex(/href=.*?go[._-]?v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "d0108e9df0041587d852d63e5811e4b0a4ae498309cf7f9dd95463ddaa581d48"
    sha256 big_sur:       "d1db2f29f84397225afccd674eef9b6c9e5a591a9372aab195b5c463d8ad6421"
    sha256 catalina:      "15f1890939c34f3eeb841c09c6b74c23c43450337d50a3f0963493a3a861b7f9"
    sha256 mojave:        "0299a79c3c05259256f5b4f10e532a3b2057423a93024f87ac99a174ec2e9d9f"
    sha256 x86_64_linux:  "65e57b46322ebb9957754293cc66012579d93a7795b286bd2f267758f8006d7b"
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
    (libexec/"src/debug/elf/testdata").rmtree
    # Binaries built for an incompatible architecture
    (libexec/"src/runtime/pprof/testdata").rmtree
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

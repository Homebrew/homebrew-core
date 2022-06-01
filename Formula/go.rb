class Go < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.18.3.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.18.3.src.tar.gz"
  sha256 "0012386ddcbb5f3350e407c679923811dbd283fcdc421724931614a842ecbc2d"
  license "BSD-3-Clause"
  head "https://go.googlesource.com/go.git", branch: "master"

  livecheck do
    url "https://go.dev/dl/"
    regex(/href=.*?go[._-]?v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "5a1b5411dad51d04469800db4107be6318bb797b693c29d9301d62a91f6d3d2e"
    sha256 arm64_big_sur:  "14c66eca407b3fa68791dede920e70b1f48ac7f91bf436886b4ff0a78517bb5c"
    sha256 monterey:       "465c96a2b01a2d9cef44dbdaa524de427538b0710c80094da49131dc798c86d6"
    sha256 big_sur:        "495264a870c648972f66d53ea9c012a020d3f90b6d709d0b5b847e290839a8e8"
    sha256 catalina:       "844c25fcf5ce4b62b83ca9707c4af079cd8997bdd1bb626f19d6c3bf03bfd4f2"
    sha256 x86_64_linux:   "03aeb9976ab5be7e4dc3a6cee10f55af30a67e026df9b60a614769055eaa61e5"
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
      if Hardware::CPU.arm?
        url "https://storage.googleapis.com/golang/go1.16.linux-arm64.tar.gz"
        version "1.16"
        sha256 "3770f7eb22d05e25fbee8fb53c2a4e897da043eb83c69b9a14f8d98562cd8098"
      else
        url "https://storage.googleapis.com/golang/go1.16.linux-amd64.tar.gz"
        version "1.16"
        sha256 "013a489ebb3e24ef3d915abe5b94c3286c070dfe0818d5bca8108f1d6e8440d2"
      end
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

class Go < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.19.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.19.src.tar.gz"
  sha256 "9419cc70dc5a2523f29a77053cafff658ed21ef3561d9b6b020280ebceab28b9"
  license "BSD-3-Clause"
  head "https://go.googlesource.com/go.git", branch: "master"

  livecheck do
    url "https://go.dev/dl/"
    regex(/href=.*?go[._-]?v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "4f80cc29d711ddc5038f6b4684fe31674df01284aaa6114801b403b0e596cca0"
    sha256 arm64_big_sur:  "dbd4e3404afcc6247ab081e624957a0788ec0e575a5cf2d0f67c7d86b50f0116"
    sha256 monterey:       "6e00cee1145b7670da77bda6db8c97c12d4d66cd4710c5b7ca2e937ad7cab03d"
    sha256 big_sur:        "bca619fed968563fb36ee8f147c8c48869feec8261a3c50ad767d088b3c1e9c3"
    sha256 catalina:       "25c03cb1f9a27d35451a8bea27aec4d851cd5c10d9ce1b194594c0a0d6912ee4"
    sha256 x86_64_linux:   "dff2b1ca994651bf3a9141a8cbc64e5ab347ac20324f064d27128022a38355b3"
  end

  # Don't update this unless this version cannot bootstrap the new version.
  resource "gobootstrap" do
    checksums = {
      "darwin-arm64" => "4dac57c00168d30bbd02d95131d5de9ca88e04f2c5a29a404576f30ae9b54810",
      "darwin-amd64" => "6000a9522975d116bf76044967d7e69e04e982e9625330d9a539a8b45395f9a8",
      "linux-arm64"  => "3770f7eb22d05e25fbee8fb53c2a4e897da043eb83c69b9a14f8d98562cd8098",
      "linux-amd64"  => "013a489ebb3e24ef3d915abe5b94c3286c070dfe0818d5bca8108f1d6e8440d2",
    }

    arch = "arm64"
    platform = "darwin"

    on_intel do
      arch = "amd64"
    end

    on_linux do
      platform = "linux"
    end

    boot_version = "1.16"

    url "https://storage.googleapis.com/golang/go#{boot_version}.#{platform}-#{arch}.tar.gz"
    version boot_version
    sha256 checksums["#{platform}-#{arch}"]
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

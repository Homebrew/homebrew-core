class GoAT119 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.19.7.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.19.7.src.tar.gz"
  sha256 "775bdf285ceaba940da8a2fe20122500efd7a0b65dbcee85247854a8d7402633"
  license "BSD-3-Clause"

  livecheck do
    url "https://go.dev/dl/"
    regex(/href=.*?go[._-]?v?(1\.19(?:\.\d+)*)[._-]src\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "c60ef2d487bc835f5517faec0f2030b8b991bfacf86f821b1530eb6b1bfc7061"
    sha256 arm64_monterey: "e52e672e364338f9aa6a5c46e375e6f0f4a75a142b135f197da2ae664543743f"
    sha256 arm64_big_sur:  "8f718370e37cad168918de62d9185a6b9f05823756373cf85b96190f4d2b3f01"
    sha256 ventura:        "1f6af2af7764cf8b54746708dc1a2105a751d6c26b3f576040cdc4cf2fa5cfa6"
    sha256 monterey:       "80bcd46bde3b726a6d68b14bcbaf0800d9f293b05e542921877ea9ebbb80e850"
    sha256 big_sur:        "0858d01fa96a6ad32aff91830c009eb9aeb67d996624def140a6ce342579c7c6"
    sha256 x86_64_linux:   "28e9ce5e8408a4569f54b1b60b658a6dc61360f0d3a716bd5caaa7ed75de1bfd"
  end

  keg_only :versioned_formula

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

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
    sha256 arm64_ventura:  "a46a8456370252e6977c98f3b4381f4583d66d53db472958e5e418bc75521891"
    sha256 arm64_monterey: "b68913931e339e827fe3d3c7af2ee2274d748c0ac4d4df4733b558878dc2532d"
    sha256 arm64_big_sur:  "cb70d673492be6ee2c97ddb15ebcb493dd354240603a323adfe405c32e3d1939"
    sha256 ventura:        "996727c3658a85fc6ae6e8ec6d5aa3f8c7116f72e5cf656591f653a97b7a3113"
    sha256 monterey:       "dbd832dc3de1803281181da47d0c14b5c806b2bfd42c50695c294526002c40ff"
    sha256 big_sur:        "54ecdc3adbb41da5300a70a514fed7007785a57f7d032038fd5b3af205ac50e0"
    sha256 x86_64_linux:   "885365c7290af0fe48e9afe6226cd8ce68d208def902706ea84d174276f57962"
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

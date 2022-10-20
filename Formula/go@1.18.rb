class GoAT118 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.18.7.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.18.7.src.tar.gz"
  sha256 "9467e33b819f71bebb21fb0ee1dd6794fd2244ae94907a984286712f9839a944"
  license "BSD-3-Clause"

  livecheck do
    url "https://go.dev/dl/"
    regex(/href=.*?go[._-]?v?(1\.18(?:\.\d+)*)[._-]src\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "139c8fea435a5e54054c48efa2613a275a5847adb264ba516a5828a9e41285bc"
    sha256 arm64_big_sur:  "14c8e9eafc8749f09fa4a283a49d2695af80cd6525c6b0eaaf54732a3200941a"
    sha256 monterey:       "7cc509841d6635b7f4f966b7b27d3e606af515455f3959b71c7421916e3cd02b"
    sha256 big_sur:        "496dceec8ececc5197246c8909f18347cb1fd456a81d6d5ed7a6915103d2a5b8"
    sha256 catalina:       "7f84899232b246f6953768aec3d7ed0172d8512295ac48b1b26a1b33c05f5e36"
    sha256 x86_64_linux:   "7e12d7e118a0e72a620a48f419188f4c0b0aa27f7f489ad4e49f332af16c8d01"
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

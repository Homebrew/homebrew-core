class Go < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.19.2.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.19.2.src.tar.gz"
  sha256 "2ce930d70a931de660fdaf271d70192793b1b240272645bf0275779f6704df6b"
  license "BSD-3-Clause"
  head "https://go.googlesource.com/go.git", branch: "master"

  livecheck do
    url "https://go.dev/dl/"
    regex(/href=.*?go[._-]?v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "54f49547f7bbad41f16ccc4b658afd5379e0ddcea95fe00e4e18d29936b7a1e1"
    sha256 arm64_big_sur:  "60761626f553e83172758af6e47e08a4551fa84cf78037f1bc8685ff133fd23b"
    sha256 monterey:       "9163696060076e2996b9c45e52c58a2fee32436ec60ffd4daedf2b08a9dc89f0"
    sha256 big_sur:        "e82d3fc704dd191302f18cf263a945aec7b2ff736c74b7734a99d0a5513b5e02"
    sha256 catalina:       "042e0203094cd3727f3e0b12052d4a02478670eec3b8881134609bba19b01ab4"
    sha256 x86_64_linux:   "e20701fdc1fdd3f70add4d0929b51e24b255e42ba2aeb929ddd6ff428f46aaf3"
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

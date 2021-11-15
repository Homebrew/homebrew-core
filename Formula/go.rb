class Go < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://golang.org"
  url "https://golang.org/dl/go1.17.2.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.17.2.src.tar.gz"
  sha256 "2255eb3e4e824dd7d5fcdc2e7f84534371c186312e546fb1086a34c17752f431"
  license "BSD-3-Clause"
  head "https://go.googlesource.com/go.git"

  livecheck do
    url "https://golang.org/dl/"
    regex(/href=.*?go[._-]?v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "fe137ea6536535299a666ea9e126e84fd58712d25c7071073bb4053da70ad2f0"
    sha256 arm64_big_sur:  "b0a1686c5c5ba668e78a97d66567e9d007f7d2a0c9b1a53e79841e3736d729e6"
    sha256 monterey:       "d40731741ca7d7b16b791fa31d21baab674720c87c00adbf54ca796ff80b9b0f"
    sha256 big_sur:        "01f50ff6dbea579b3b3e792751ec14ba90de1ac5fe09db03adf438558444ddfa"
    sha256 catalina:       "cc6b0bff088b30b80afad3be3519af192e515d83c8928262114ca07e9bf34bd8"
    sha256 mojave:         "a98bd1c5f1cae4907712126d9ea040680084e5fb9743f1d4160744fe3fe8861a"
    sha256 x86_64_linux:   "aa5fbcd2c12be4e08d5edbcbb5eb8a8859c48ecd036c697d2d83b62d410dbd8c"
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

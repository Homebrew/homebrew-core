class Go < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.17.7.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.17.7.src.tar.gz"
  sha256 "c108cd33b73b1911a02b697741df3dea43e01a5c4e08e409e8b3a0e3745d2b4d"
  license "BSD-3-Clause"
  head "https://go.googlesource.com/go.git", branch: "master"

  livecheck do
    url "https://go.dev/dl/"
    regex(/href=.*?go[._-]?v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "b7397f2bb5f35e87677581fab0441698614ed74d2faf10fc9d82a157945cd4b6"
    sha256 arm64_big_sur:  "498f7212b386b369965b101a795320eed1f6327d8b51a4e5d6158c4b527c2df1"
    sha256 monterey:       "c81555a115fbd99ab1c74e9b3e1d056864c31a4274803381230984f4a70fdf63"
    sha256 big_sur:        "ee3c6b380b93482e56620f7962bde13c2492131b15cdd37ce925dc1d6db9efcf"
    sha256 catalina:       "f7a522d413b3b5fc47305a3851e0148a63b2786f22796399feb6788af92adb14"
    sha256 x86_64_linux:   "4b4c9d51934b2c75fa32dcfb239363673a2bb471388f53976a98151489e00209"
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

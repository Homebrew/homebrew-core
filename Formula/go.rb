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
    sha256 arm64_monterey: "f9bfa7562421ece3c7bebe5eb2ea733286b33c009a2f24b932b82978b3e97446"
    sha256 arm64_big_sur:  "7b405fbace1164c8e28f98f4b005a5b853f033ff08b0da43a7f2e31c203a1d53"
    sha256 monterey:       "d99358b9ca6dadc9298ef1164d69fadd31ccbadd6fa21f2ddd71018164813395"
    sha256 big_sur:        "687d07f5cf904d7cdb83a9290e646677717a39c28e52de427d14518ab027339d"
    sha256 catalina:       "60038eabf8a61afc20dc9031124287b5faf99600613318645850db4b6757b5b4"
    sha256 x86_64_linux:   "e1a92e8cb4f7fe7bdecaf8ec846b02915af1f0ba3329d1c7a4bf7d0981319fb5"
  end

  # Don't update this unless this version cannot bootstrap the new version.
  resource "gobootstrap" do
    checksums = {
      "darwin-arm64" => "4dac57c00168d30bbd02d95131d5de9ca88e04f2c5a29a404576f30ae9b54810",
      "darwin-amd64" => "6000a9522975d116bf76044967d7e69e04e982e9625330d9a539a8b45395f9a8",
      "linux-arm64"  => "3770f7eb22d05e25fbee8fb53c2a4e897da043eb83c69b9a14f8d98562cd8098",
      "linux-amd64"  => "013a489ebb3e24ef3d915abe5b94c3286c070dfe0818d5bca8108f1d6e8440d2",
    }

    arch = Hardware::CPU.intel? ? :amd64 : Hardware::CPU.arch
    platform = "#{OS.kernel_name.downcase}-#{arch}"
    boot_version = "1.16"

    url "https://storage.googleapis.com/golang/go#{boot_version}.#{platform}.tar.gz"
    version boot_version
    sha256 checksums[platform]
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

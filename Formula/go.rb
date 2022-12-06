class Go < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.19.4.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.19.4.src.tar.gz"
  sha256 "eda74db4ac494800a3e66ee784e495bfbb9b8e535df924a8b01b1a8028b7f368"
  license "BSD-3-Clause"
  head "https://go.googlesource.com/go.git", branch: "master"

  livecheck do
    url "https://go.dev/dl/"
    regex(/href=.*?go[._-]?v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "6e7f284d44cfd7cb22e783350c428154b6a7867bef3eb4c40c2c914d0fc6fd7f"
    sha256 arm64_monterey: "5566ef32f95654fb2729d739e8d5208848b83b577c82c873c98ef9c8b9c79406"
    sha256 arm64_big_sur:  "251e3c47fa7fc5beee48c41037a736cc13c5d3d1b8e62c69a612419aa99ec493"
    sha256 ventura:        "029df5024e097c0c44b556c457c0bc242a1f4ca6ef3d092349da0983cba3d2f2"
    sha256 monterey:       "30f1ceb685ec8589c2b40f832cdbf45f23354704d109b1c428bfe5952791c5f3"
    sha256 big_sur:        "4f8b1fae32e814117d3fe23880f66d94bbff7951933d60ae26402f081e693f06"
    sha256 catalina:       "2b29ff8bc520e4fd469248ddb1e79bb8c2714c6a06430f80b3a26ac5c1886bb9"
    sha256 x86_64_linux:   "0eef78ee9d77f1e81eb233d2459181438cc26b3400f746206a83addcfa63cca7"
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

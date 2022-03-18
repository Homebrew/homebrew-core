class Go < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.18.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.18.src.tar.gz"
  sha256 "38f423db4cc834883f2b52344282fa7a39fbb93650dc62a11fdf0be6409bdad6"
  license "BSD-3-Clause"
  head "https://go.googlesource.com/go.git", branch: "master"

  livecheck do
    url "https://go.dev/dl/"
    regex(/href=.*?go[._-]?v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "6537caf925f0a3ec1875c55b88a4184d58fc604f6979397b22e4b2a257175af1"
    sha256 arm64_big_sur:  "fdc0d8e3047cc35f601e1b8c8381bd50594711db9b90e81f01430b864a8ef579"
    sha256 monterey:       "8e95cccc916d40254e2a56449fac8f4a5e36d86d63b619793ff1f372bae387a1"
    sha256 big_sur:        "62e6d0bdf5effc5b98f5de7004f7c70e4f27f120f334302622829f37f65676e8"
    sha256 catalina:       "7d769c4b648931964a38850fa2774d40d2832ebecfeba97c35645f430ba80ab4"
    sha256 x86_64_linux:   "2c529a79f41ffc505361700c502661d9b6e0e11050d86f5dc6ff488ce854f4ac"
  end

  # Don't update this unless this version cannot bootstrap the new version.
  resource "gobootstrap" do
    on_macos do
      if Hardware::CPU.arm?
        url "https://storage.googleapis.com/golang/go1.18.darwin-arm64.tar.gz"
        version "1.18"
        sha256 "9cab6123af9ffade905525d79fc9ee76651e716c85f1f215872b5f2976782480"
      else
        url "https://storage.googleapis.com/golang/go1.18.darwin-amd64.tar.gz"
        version "1.18"
        sha256 "70bb4a066997535e346c8bfa3e0dfe250d61100b17ccc5676274642447834969"
      end
    end

    on_linux do
      if Hardware::CPU.arm?
        url "https://storage.googleapis.com/golang/go1.18.linux-arm64.tar.gz"
        version "1.18"
        sha256 "7ac7b396a691e588c5fb57687759e6c4db84a2a3bbebb0765f4b38e5b1c5b00e"
      else
        url "https://storage.googleapis.com/golang/go1.18.linux-amd64.tar.gz"
        version "1.18"
        sha256 "e85278e98f57cdb150fe8409e6e5df5343ecb13cebf03a5d5ff12bd55a80264f"
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

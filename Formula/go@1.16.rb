class GoAT116 < Formula
  desc "Go programming environment (1.16)"
  homepage "https://golang.org"
  url "https://golang.org/dl/go1.16.9.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.16.9.src.tar.gz"
  sha256 "0a1cc7fd7bd20448f71ebed64d846138850d5099b18cf5cc10a4fc45160d8c3d"
  license "BSD-3-Clause"

  livecheck do
    url "https://golang.org/dl/"
    regex(/href=.*?go[._-]?v?(1\.16(?:\.\d+)*)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "be131fb3bf7494645b978f60ec191a1bfa721b1ecf492b5c2d5faf4f7aa425c7"
    sha256 cellar: :any_skip_relocation, big_sur:       "cd7cf2ab4fff304367bc25472fdf1c87710735edd16f0dd26e3fee091b00f2b5"
    sha256 cellar: :any_skip_relocation, catalina:      "2f6a5856c9cc124335c1c85d35bfc344bff1aeb88215aa8fa3cde62e62d229b1"
    sha256 cellar: :any_skip_relocation, mojave:        "3c6db9bd28d82d8e8c5e09157faffe667b044c6c9296fe68b5657abe129b5d7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fa164e41dfc4c78ad1fc74d5f79805c200f5503e1c9b287c7a143fa7256a477"
  end

  keg_only :versioned_formula

  depends_on "go" => :build

  def install
    ENV["GOROOT_BOOTSTRAP"] = Formula["go"].opt_libexec

    cd "src" do
      ENV["GOROOT_FINAL"] = libexec
      system "./make.bash", "--no-clean"
    end

    (buildpath/"pkg/obj").rmtree
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
    ENV["GOARCH"] = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    system bin/"go", "build", "hello.go"
  end
end

class GoAT116 < Formula
  desc "Go programming environment (1.16)"
  homepage "https://golang.org"
  url "https://golang.org/dl/go1.16.8.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.16.8.src.tar.gz"
  sha256 "8f2a8c24b793375b3243df82fdb0c8387486dcc8a892ca1c991aa99ace086b98"
  license "BSD-3-Clause"

  livecheck do
    url "https://golang.org/dl/"
    regex(/href=.*?go[._-]?v?(1\.16(?:\.\d+)*)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "61a8e5ffff7f3cc2f5911dd240e15665292fc4bc40dafbf3e90d055593fe5b17"
    sha256 cellar: :any_skip_relocation, big_sur:       "b89c4137abac33c6927271a364f26370b713fa8368c32444ba5611ddff5ec596"
    sha256 cellar: :any_skip_relocation, catalina:      "e25d15e8cd0fc4885f730cb5778fda940365add125c9c414c9eafbd15905044d"
    sha256 cellar: :any_skip_relocation, mojave:        "c68397c5bbf57d624ad3663fd10228b8284f17d3d1565f770541db842d6521b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9e1c4e93690d0effb3fdb94a63a1b10f645af66b43fdd787dbdaf2f50ec8850"
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

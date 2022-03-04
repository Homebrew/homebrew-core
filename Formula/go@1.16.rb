class GoAT116 < Formula
  desc "Go programming environment (1.16)"
  homepage "https://golang.org"
  url "https://golang.org/dl/go1.16.15.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.16.15.src.tar.gz"
  sha256 "90a08c689279e35f3865ba510998c33a63255c36089b3ec206c912fc0568c3d3"
  license "BSD-3-Clause"

  livecheck do
    url "https://golang.org/dl/"
    regex(/href=.*?go[._-]?v?(1\.16(?:\.\d+)*)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d000f53accc3fabf34901a968b12483e78b878fb5364b91b91d05cf19b988ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "748ff22b57df70e5c23179d63a7274151bb0e1417913a1edc5c54363c141794e"
    sha256 cellar: :any_skip_relocation, monterey:       "01648bc36c74e01a9805f144a68bd0ab1782de6b69d04a20c3b622c884e50aac"
    sha256 cellar: :any_skip_relocation, big_sur:        "dbcafd5888d3bc10e8ac31343ee43e891fc3dfe4e2e06b0c14653f54121838ec"
    sha256 cellar: :any_skip_relocation, catalina:       "cd2e3e4aba2aea16034f1840aac97e17fcb99e7dedbf8b7c6f957368b3434d41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a835cfa697e8e5f16f18f95ced4466be2d7667eba1493c9bd17b8d0aa42a6b3"
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

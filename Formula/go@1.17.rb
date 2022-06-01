class GoAT117 < Formula
  desc "Go programming environment (1.17)"
  homepage "https://golang.org"
  url "https://go.dev/dl/go1.17.11.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.17.11.src.tar.gz"
  sha256 "ac2649a65944c6a5abe55054000eee3d77196880da36a3555f62e06540e8eb54"
  license "BSD-3-Clause"

  livecheck do
    url "https://golang.org/dl/"
    regex(/href=.*?go[._-]?v?(1\.17(?:\.\d+)*)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c475ad02611590cc70503d4732b856e960b0fb85f5f711f76b5b493bf1e8172"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92ce6be730b907198ff4d28b5decaaa7ff7b9cf064152ac601b2ea57f7a2c0b6"
    sha256 cellar: :any_skip_relocation, monterey:       "0619144de1405962e6ea49cefdb4b025cae1eb2758ae5eca49e119a36b58bf45"
    sha256 cellar: :any_skip_relocation, big_sur:        "2353e05cbbaf04f8314f803387ca2e1c18afaa4ba9e6fe6359409ac5a808baa8"
    sha256 cellar: :any_skip_relocation, catalina:       "57a813de721adf34738290df6e00b2fcdf07c870d21203256c9db55c3180eb0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afcb2652d84cbe7157de0d05872cd41f56bbb868125c293155f515da2e4a61e0"
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

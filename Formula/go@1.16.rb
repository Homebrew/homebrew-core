class GoAT116 < Formula
  desc "Go programming environment (1.16)"
  homepage "https://golang.org"
  url "https://golang.org/dl/go1.16.10.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.16.10.src.tar.gz"
  sha256 "a905472011585e403d00d2a41de7ced29b8884309d73482a307f689fd0f320b5"
  license "BSD-3-Clause"

  livecheck do
    url "https://golang.org/dl/"
    regex(/href=.*?go[._-]?v?(1\.16(?:\.\d+)*)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "205bb5915e4068f5b47263f568e5aa75072a536c4958412c913940e6035b9d2c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cae38a28a48c89de059d80a935967a90874436f63e06383069ef8c200e48496e"
    sha256 cellar: :any_skip_relocation, monterey:       "6ea3cb1ede7d3bdd8052c7d2d0e805ce01878fd84f83e2c1b5296b38a62ff58e"
    sha256 cellar: :any_skip_relocation, big_sur:        "da99d2ff8160e5ff2b35230873c3c02c2e87fa41b21d30517e01692c86c0b4c9"
    sha256 cellar: :any_skip_relocation, catalina:       "ef304ea8197dc3132753cc7d7f3f311d8801bbb84a1deab925fa31f2637dd63f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68aa1bef17f027de5d775b79781d8c5498a40d7673694a5457abdbb70631586b"
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

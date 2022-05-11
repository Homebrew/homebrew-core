class GoAT117 < Formula
  desc "Go programming environment (1.17)"
  homepage "https://golang.org"
  url "https://go.dev/dl/go1.17.10.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.17.10.src.tar.gz"
  sha256 "299e55af30f15691b015d8dcf8ecae72412412569e5b2ece20361753a456f2f9"
  license "BSD-3-Clause"

  livecheck do
    url "https://golang.org/dl/"
    regex(/href=.*?go[._-]?v?(1\.17(?:\.\d+)*)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f689c1f529a0db7205a95588ae4baa0a1f7ed498594faa77834e88023cc5e6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbc2fd720b8b34a984d36949b903e38590eafcc15e477f0a1106d5ac8863613e"
    sha256 cellar: :any_skip_relocation, monterey:       "9c64162ceb17602f54a6b54c9b362e3f2481d120f15275a6b614ebe96dec62c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c3e7d1933b9a2ddb17fc2202b04ea6e10bc900867e20fed25924dee4e742282"
    sha256 cellar: :any_skip_relocation, catalina:       "eb5d26f43c03e0878384fe73cf3cdcc353afeb809993a49ec20f7c50e9217614"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dae10835cd12930353160fcf587641370365edf681c54dd2be692ac321b13bac"
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

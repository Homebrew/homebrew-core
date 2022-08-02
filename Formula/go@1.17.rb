class GoAT117 < Formula
  desc "Go programming environment (1.17)"
  homepage "https://golang.org"
  url "https://go.dev/dl/go1.17.13.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.17.13.src.tar.gz"
  sha256 "a1a48b23afb206f95e7bbaa9b898d965f90826f6f1d1fc0c1d784ada0cd300fd"
  license "BSD-3-Clause"

  livecheck do
    url "https://golang.org/dl/"
    regex(/href=.*?go[._-]?v?(1\.17(?:\.\d+)*)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd8f10b31304b45f9ff264c02f7125fda5e3d63653ea124547ea950405fd35f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "daff9f53e775af2fad097d61426a0b8c6110dd4b917258ea8e94cf67f186c360"
    sha256 cellar: :any_skip_relocation, monterey:       "b55bc79ab7381d32c869f2e66d0a0a948621bba461de676b68090660a14d3ece"
    sha256 cellar: :any_skip_relocation, big_sur:        "9586fe17107321dc29ff369242441601ed01cf8650c9c2ed119a54f0a06c2466"
    sha256 cellar: :any_skip_relocation, catalina:       "a13920ae3df1c35bbbc4acb5c38fb2285573687924b27c6b6cd5aaa350cc39a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0630c4aa97a01320c38807169138c15aeb496436a77e1f09b1dc1e1059cebe84"
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

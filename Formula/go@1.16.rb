class GoAT116 < Formula
  desc "Go programming environment (1.16)"
  homepage "https://golang.org"
  url "https://golang.org/dl/go1.16.12.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.16.12.src.tar.gz"
  sha256 "2afd839dcb76d2bb082c502c01a0a5cdbfc09fd630757835363c4fde8e2fbfe8"
  license "BSD-3-Clause"

  livecheck do
    url "https://golang.org/dl/"
    regex(/href=.*?go[._-]?v?(1\.16(?:\.\d+)*)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "163752145d80384e05c70a681a26b27b8ef387ffb3e98bbe8409467a9fb870f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4c4df3d2bb2463f47ffc717e3d68a3c84195f5f6657a507429b3126f2116de1"
    sha256 cellar: :any_skip_relocation, monterey:       "4631f80fc40ca60eeb3e69f5f6a020581b5a368e48ae7696f73ebbd16032cba8"
    sha256 cellar: :any_skip_relocation, big_sur:        "a51315e51ebe56f80462c1b5c21eccfc38667c04ebb025373e7ece915c22a9ed"
    sha256 cellar: :any_skip_relocation, catalina:       "b0035d77182dfdeeaee004c6a78e19600203bb88e328358068401578717037f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5951504bcf6594dcfd27d92697d7cbe3c94d91829c147a2d7ff095d854f33a03"
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

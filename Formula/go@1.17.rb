class GoAT117 < Formula
  desc "Go programming environment (1.17)"
  homepage "https://golang.org"
  url "https://go.dev/dl/go1.17.8.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.17.8.src.tar.gz"
  sha256 "2effcd898140da79a061f3784ca4f8d8b13d811fb2abe9dad2404442dabbdf7a"
  license "BSD-3-Clause"

  livecheck do
    url "https://golang.org/dl/"
    regex(/href=.*?go[._-]?v?(1\.17(?:\.\d+)*)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1d95da3dbd51fafbdef75f0972c349731abf6383e42d2a9195ee5d8af2c597e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2aa597f403e1e49750d2b33326acf732ec9a7fe641323f6d8f43459d58b200e7"
    sha256 cellar: :any_skip_relocation, monterey:       "91a94891156ca601d423e08a3bef8a49a07fb6bbd60afb7c2d6c7d211f5035a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "97f5b0b9f4df2eb70864fe8624a60f4809e14da1baacdb010d292bbac8cbd75e"
    sha256 cellar: :any_skip_relocation, catalina:       "9f55d71308b9dbbac1eec44bbdfc710ec45aae6ab07ced3bd47a4ed7a718e942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7697a1524d87c14443732405d54c9d6281a453045f5eb64e264e1da6c4f62c6"
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

class GoAT116 < Formula
  desc "Go programming environment (1.16)"
  homepage "https://golang.org"
  url "https://golang.org/dl/go1.16.13.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.16.13.src.tar.gz"
  sha256 "b0926654eaeb01ef43816638f42d7b1681f2d3f41b9559f07735522b7afad41a"
  license "BSD-3-Clause"

  livecheck do
    url "https://golang.org/dl/"
    regex(/href=.*?go[._-]?v?(1\.16(?:\.\d+)*)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5177e50de5b4d2687a61053eead7a87b65d8efe390970345969edce5dc630ba2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d3c8e8ab07154ac960a630e9f3c07ba3a9f673d14e6b0edb66ee47faf59a8fd"
    sha256 cellar: :any_skip_relocation, monterey:       "57f8a5eea9e84406b6f691781b6fab1bf96f72c80a3f892887fb21f19888bf75"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a1e251a16fd3257d38389ae571df94721f1a62ab115f7c969c26c4a65b03e30"
    sha256 cellar: :any_skip_relocation, catalina:       "3a990ccead37a49f6d6d21897eb9441d55876ab73f53a0b01a7ea7f59c298fb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ba5a29d6b43c1b88a42266055811540d65a962765658b85d4252c8229bc764d"
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

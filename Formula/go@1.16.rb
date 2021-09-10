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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b0c1d66b93db44100aaff13db28c4f72a957647ae8bc6d3883589051694841f4"
    sha256 cellar: :any_skip_relocation, big_sur:       "5025baf8fea14c61cbe0f0e797f9eba3a54ca9bae474324cc58b740e21370b56"
    sha256 cellar: :any_skip_relocation, catalina:      "c7bf89d6cc4adcc21fdb4a46acd95b59ee056bab60923848acd83480393286bf"
    sha256 cellar: :any_skip_relocation, mojave:        "004114a71d46cc558a211623e1f1c8305cf4a9fe963aec277ee324bffdc89056"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af0f4c5162491c414d4d4d952b158eca702d8c3fa2513b0fc61079ed2b10604c"
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

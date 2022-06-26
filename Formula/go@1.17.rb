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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e45e896314e1a1a867b6f8ce5224cd7d97444f75b9444855fa3d1ce5edf4f62d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "672040c35ae9b624cdf4bf3a5df0c37e23b7ae954a85f471aa90703c04510f80"
    sha256 cellar: :any_skip_relocation, monterey:       "7246c764e1be7b59fa8c8cc32ab931e3cca3fb431be090974ebc6a954bbd095e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8aa78fdffb16a5073b72e019c8d68652d7a28c02d88a992e5922757e3e486b5"
    sha256 cellar: :any_skip_relocation, catalina:       "0add34b40fde58be04c143a0f45167f31d298459ecad909762e7b0e846619d6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4393af12ffa90f0b6807422640669c94272b7a8df3dec5084c89603bae01d3ea"
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

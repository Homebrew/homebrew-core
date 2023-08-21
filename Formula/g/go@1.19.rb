class GoAT119 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.19.12.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.19.12.src.tar.gz"
  sha256 "ee5d50e0a7fd74ba1b137cb879609aaaef9880bf72b5d1742100e38ae72bb557"
  license "BSD-3-Clause"

  livecheck do
    url "https://go.dev/dl/"
    regex(/href=.*?go[._-]?v?(1\.19(?:\.\d+)*)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db23b7875ee6f0aba7b55244439aa6807b059fe1d8e317ff0f273f86b4591ebe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b719fda8b9e23e6d706ee6c859faf284146c7844e4ccf8529651e16133dffdb8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "590cf4cb8267e85f8011e534ed09d5ce23aca2015ae9a42f80592dd3aadb5e1f"
    sha256 cellar: :any_skip_relocation, ventura:        "739af06a9c00048a540989883316a2c7bdcc1f5891ea50062c92cf45ac5fc2b1"
    sha256 cellar: :any_skip_relocation, monterey:       "8af5062cd46e83c742bb364a3ce7461123eb78409721b70edee1ff5e4d7ce02a"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d12b6df03afca6e663b93057dc0e77cc1a6af20080336a24bb4d2b28b9bb835"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6adc61aafa3730667210d84fc4288cf3104797627982adf957b20c7e8088dd08"
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
    ENV["GOARCH"] = "amd64"
    system bin/"go", "build", "hello.go"
  end
end

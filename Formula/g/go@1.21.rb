class GoAT121 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.21.13.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.21.13.src.tar.gz"
  sha256 "71fb31606a1de48d129d591e8717a63e0c5565ffba09a24ea9f899a13214c34d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "753f1a7914bc53660aa8625690faedfe243e1dc0026d0265985321598e188386"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e70be09433f39ccefc348359ddc317acc74fca91bdfef36be59e07aef4d014f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c49b9a80d8d0e33df0de46859cf7cc89e27343d0ba7f38d09ffeab8dbb10549"
    sha256 cellar: :any_skip_relocation, sonoma:         "76bfebd5a396fde119f4046af3d435eb28eac3974475f915e132922502e628b3"
    sha256 cellar: :any_skip_relocation, ventura:        "1e259f4ba9faf08f6816a32a5404de6fa17f7de93e85de7a12dfdf2a22f1eab6"
    sha256 cellar: :any_skip_relocation, monterey:       "10591630d63b94757b26c708787b81700ddfc5d5c44280e869a7c8c1cf21574a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e18ce9e4b70b577f4b87a65b18d27858cfa9aa4886a71626013598050a4a1806"
  end

  keg_only :versioned_formula

  # EOL with Go 1.23 release (2024-08-13)
  # Ref: https://go.dev/doc/devel/release#policy
  deprecate! date: "2024-08-16", because: :unsupported

  depends_on "go" => :build

  def install
    ENV["GOROOT_BOOTSTRAP"] = buildpath/"gobootstrap"

    cd "src" do
      ENV["GOROOT_FINAL"] = libexec
      # Set portable defaults for CC/CXX to be used by cgo
      with_env(CC: "cc", CXX: "c++") { system "./make.bash" }
    end

    libexec.install Dir["*"]
    bin.install_symlink Dir[libexec/"bin/go*"]

    system bin/"go", "install", "std", "cmd"

    # Remove useless files.
    # Breaks patchelf because folder contains weird debug/test files
    rm_r(libexec/"src/debug/elf/testdata")
    # Binaries built for an incompatible architecture
    rm_r(libexec/"src/runtime/pprof/testdata")
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

    with_env(GOOS: "freebsd", GOARCH: "amd64") do
      system bin/"go", "build", "hello.go"
    end

    (testpath/"hello_cgo.go").write <<~EOS
      package main

      /*
      #include <stdlib.h>
      #include <stdio.h>
      void hello() { printf("%s\\n", "Hello from cgo!"); fflush(stdout); }
      */
      import "C"

      func main() {
          C.hello()
      }
    EOS

    # Try running a sample using cgo without CC or CXX set to ensure that the
    # toolchain's default choice of compilers work
    with_env(CC: nil, CXX: nil) do
      assert_equal "Hello from cgo!\n", shell_output("#{bin}/go run hello_cgo.go")
    end
  end
end

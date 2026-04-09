class GoAT124 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.24.13.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.24.13.src.tar.gz"
  sha256 "639a6204c2486b137df1eb6e78ee3ed038f9877d0e4b5a465e796a2153f858d7"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5e92d0e6854fce804752c6f1d45620e77467bea4b3c0d608637e518fdf73476"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5e92d0e6854fce804752c6f1d45620e77467bea4b3c0d608637e518fdf73476"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5e92d0e6854fce804752c6f1d45620e77467bea4b3c0d608637e518fdf73476"
    sha256 cellar: :any_skip_relocation, sonoma:        "616b47e950116307c0ae4d65268b71e402e8aa3e929682b305b3efe63e2c3391"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93b46017e4b747affbf00aef9430b83542af6b0d7d976051cbbec640e2db3fc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dca0a28ed7d6045be29ce5f632513d33302302706ef6e6f64cb90f1ff60fe446"
  end

  keg_only :versioned_formula

  # EOL with Go 1.26 release (2026-02-10)
  # Ref: https://go.dev/doc/devel/release#policy
  deprecate! date: "2026-02-11", because: :unsupported

  depends_on "go" => :build

  # patch to fix pkg-config flag sanitization
  patch do
    url "https://github.com/golang/go/commit/28fbdf7acb4146b5bc3d88128e407d1344691839.patch?full_index=1"
    sha256 "2e05f7e16f2320685547a7ebb240163a8b7f1c7bf9d2f6dc4872ff8b27707a35"
  end

  def install
    libexec.install Dir["*"]

    cd libexec/"src" do
      # Set portable defaults for CC/CXX to be used by cgo
      with_env(CC: "cc", CXX: "c++") { system "./make.bash" }
    end

    bin.install_symlink Dir[libexec/"bin/go*"]

    # Remove useless files.
    # Breaks patchelf because folder contains weird debug/test files
    rm_r(libexec/"src/debug/elf/testdata")
    # Binaries built for an incompatible architecture
    rm_r(libexec/"src/runtime/pprof/testdata")
    # Remove testdata with binaries for non-native architectures.
    rm_r(libexec/"src/debug/dwarf/testdata")
  end

  test do
    (testpath/"hello.go").write <<~GO
      package main

      import "fmt"

      func main() {
          fmt.Println("Hello World")
      }
    GO

    # Run go fmt check for no errors then run the program.
    # This is a a bare minimum of go working as it uses fmt, build, and run.
    system bin/"go", "fmt", "hello.go"
    assert_equal "Hello World\n", shell_output("#{bin}/go run hello.go")

    with_env(GOOS: "freebsd", GOARCH: "amd64") do
      system bin/"go", "build", "hello.go"
    end

    (testpath/"hello_cgo.go").write <<~GO
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
    GO

    # Try running a sample using cgo without CC or CXX set to ensure that the
    # toolchain's default choice of compilers work
    with_env(CC: nil, CXX: nil, CGO_ENABLED: "1") do
      assert_equal "Hello from cgo!\n", shell_output("#{bin}/go run hello_cgo.go")
    end
  end
end

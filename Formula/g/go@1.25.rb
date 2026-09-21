class GoAT125 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.25.14.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.25.14.src.tar.gz"
  sha256 "9e83f44f5fc297378861b4e16cc6aa114be8add7993fb3ceb2c512380aa4d582"
  license "BSD-3-Clause"
  compatibility_version 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "45f63fcb12c3bc031fb0304c2d4ee447af77be324694f4e2c1474fd86a7608ca"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "61be046a0f2c3b9728763ae50ffa7448914c8737a460a4ea7189b877b8277b24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "61be046a0f2c3b9728763ae50ffa7448914c8737a460a4ea7189b877b8277b24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "61be046a0f2c3b9728763ae50ffa7448914c8737a460a4ea7189b877b8277b24"
    sha256 cellar: :any_skip_relocation, sonoma:            "f527080db7d49d44f8109865ad789176c2a18e83a504ba677aceb28bbb65639a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "58aaf180a983cdf77496541decd3da1156475c2b59563e20faa7f76da03c36fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "dcbaff73ded3ccaec1ced8458af91585e119f9511725ca7f7a10a236a0a9dd5e"
  end

  keg_only :versioned_formula

  # EOL with Go 1.27 release (2026-08-19)
  # Ref: https://go.dev/doc/devel/release#policy
  deprecate! date: "2026-08-25", because: :unsupported
  disable! date: "2027-08-25", because: :unsupported

  depends_on "go" => :build

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

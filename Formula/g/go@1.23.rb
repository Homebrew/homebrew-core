class GoAT123 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.23.12.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.23.12.src.tar.gz"
  sha256 "e1cce9379a24e895714a412c7ddd157d2614d9edbe83a84449b6e1840b4f1226"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "645e0a126fdc94ae63d6ccf5c8bfbda011eff7d512ac4fe04bf39edafa4b941e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7402b2b0c649679d3fdaa22d6b0f44a5fb18fb1ca2f52d27b0d791e530542764"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7402b2b0c649679d3fdaa22d6b0f44a5fb18fb1ca2f52d27b0d791e530542764"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7402b2b0c649679d3fdaa22d6b0f44a5fb18fb1ca2f52d27b0d791e530542764"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ac67f6811b895edc648ded2acd6afdc0c27c67e4282d7587844149efda71381"
    sha256 cellar: :any_skip_relocation, ventura:       "8ac67f6811b895edc648ded2acd6afdc0c27c67e4282d7587844149efda71381"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8be9fd5cf349d51a94d755c984778da07bd5810e9055f7be5e69cf168270bca2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bfd890b2b3959f0a192d0308f018c4d97447652aede2fc860d418afc47e4bcc"
  end

  keg_only :versioned_formula

  # EOL with Go 1.25 release (2025-08-12)
  # Ref: https://go.dev/doc/devel/release#policy
  deprecate! date: "2025-08-12", because: :unsupported

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
    with_env(CC: nil, CXX: nil) do
      assert_equal "Hello from cgo!\n", shell_output("#{bin}/go run hello_cgo.go")
    end
  end
end

class GoAT122 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.22.12.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.22.12.src.tar.gz"
  sha256 "012a7e1f37f362c0918c1dfa3334458ac2da1628c4b9cf4d9ca02db986e17d71"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "acc7ca078e496fe975c4a46a2d56c70071b84aee83afa23661f54df536bf5aa7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af5d726bee9702a638b3d311f14be29925d351537b861673710b68facfac9b8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "095b712e18e4f6893d3a0e205c4b72bfa25854fd4fe56af648f182f1f8cb91cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44f45e7dd769697e468306491890267cd6292e7d4bddfccf0c4a4ce084369df4"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c868fe847318a435d895dc3f94891cd39fe3ed94c0092e064f456314ecef2e7"
    sha256 cellar: :any_skip_relocation, ventura:       "9861be855108e1e3af8d4308b75e0ff1fadfa78700c3d05e9eacd52e6c6e6e38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08a31afc37fc7b016b0c3e0bc2729e32e0b0c08963fa7956c47d0360db3ae87d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5defb9fc2eb520604212c0617062dc3a1a3a6aa6c51269d32913ab1fe886308"
  end

  keg_only :versioned_formula

  # EOL with Go 1.24 release (2025-02-11)
  # Ref: https://go.dev/doc/devel/release#policy
  deprecate! date: "2025-02-16", because: :unsupported

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

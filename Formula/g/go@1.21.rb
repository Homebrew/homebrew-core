class GoAT121 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.21.13.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.21.13.src.tar.gz"
  sha256 "71fb31606a1de48d129d591e8717a63e0c5565ffba09a24ea9f899a13214c34d"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 arm64_sequoia: "0653847518101d80daf1da2b2e14a2c6fd76c5821c6692ab8b0a492bfdb1761d"
    sha256 arm64_sonoma:  "67a54a23b293d32ac840196dd114014e6d4b816861aa5a8422a0b1d1850fe7f9"
    sha256 arm64_ventura: "baa064afbd10120172949e2632e9495537936a063bb73cbcee7b8136ca03441a"
    sha256 sonoma:        "2e6c282c3dde6d05a2aad83939b28232521afa4530c2dd102e4092bd3faf32f0"
    sha256 ventura:       "938a31dbe05636643409366c61afc7a6ba5d80abe3f591f8bb8846656e02e764"
    sha256 x86_64_linux:  "c492b2a277c6abd6ab43cc429277882b5fb23f7195cb3f8aafdcfe41d6dad134"
  end

  keg_only :versioned_formula

  # EOL with Go 1.23 release (2024-08-13)
  # Ref: https://go.dev/doc/devel/release#policy
  deprecate! date: "2024-08-16", because: :unsupported
  disable! date: "2025-08-16", because: :unsupported

  depends_on "go" => :build

  def install
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

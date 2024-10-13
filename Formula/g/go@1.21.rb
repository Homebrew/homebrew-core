class GoAT121 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.21.13.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.21.13.src.tar.gz"
  sha256 "71fb31606a1de48d129d591e8717a63e0c5565ffba09a24ea9f899a13214c34d"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f38f1b1d5915fc6e17cbb18f66cd0ed7160c61b8c9ee9269979631d190de2918"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c3757ac40700cd4d517029a65b116d6f77566a6a94c40c4596fe1260197b0a36"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b87a776feaba8fa2acf3ed011a9975889605934252863494074b611bb45bb10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bcb9ea33785b35225901a94a79dafe6dd966772932afcded0267095ad473555"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6a9eb12dc8b09ac64043d014e0d2c4eae6d4037eb04d2716910b1915d790846"
    sha256 cellar: :any_skip_relocation, ventura:        "ae6a9a23003e4d35ec7ad3c49ef019bd5eb601d3c4fbcae22855214b540f48f9"
    sha256 cellar: :any_skip_relocation, monterey:       "cc9f41285f92be8306f1d46186042b16daba3ab78977e2cba24ccb72e278d416"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e99701f6ff4d7a776573f0a5b98bfd68194cc7abaa5dc28534142a8426a0f1dc"
  end

  keg_only :versioned_formula

  # EOL with Go 1.23 release (2024-08-13)
  # Ref: https://go.dev/doc/devel/release#policy
  deprecate! date: "2024-08-16", because: :unsupported

  depends_on "go" => :build

  def install
    inreplace "go.env", /^GOTOOLCHAIN=.*$/, "GOTOOLCHAIN=local"

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

  def caveats
    <<~EOS
      Homebrew's Go toolchain is configured with
        GOTOOLCHAIN=local
      per Homebrew policy on tools that update themselves.
    EOS
  end

  test do
    assert_equal "local", shell_output("#{bin}/go env GOTOOLCHAIN").strip

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

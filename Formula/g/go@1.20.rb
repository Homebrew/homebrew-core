class GoAT120 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.20.7.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.20.7.src.tar.gz"
  sha256 "2c5ee9c9ec1e733b0dbbc2bdfed3f62306e51d8172bf38f4f4e542b27520f597"
  license "BSD-3-Clause"

  livecheck do
    url "https://go.dev/dl/"
    regex(/href=.*?go[._-]?v?(1\.20(?:\.\d+)*)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7748988781f6f17dca24802fa1c8507d004421052152ad7d322739fa8e9afa2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7748988781f6f17dca24802fa1c8507d004421052152ad7d322739fa8e9afa2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7748988781f6f17dca24802fa1c8507d004421052152ad7d322739fa8e9afa2"
    sha256 cellar: :any_skip_relocation, ventura:        "1b80b34c50e7b5e6eec656bbb5a046e3b088755142bbed0492d25afea84a621b"
    sha256 cellar: :any_skip_relocation, monterey:       "1b80b34c50e7b5e6eec656bbb5a046e3b088755142bbed0492d25afea84a621b"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b80b34c50e7b5e6eec656bbb5a046e3b088755142bbed0492d25afea84a621b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76e2c75958b2a6eca9533c3966709bea357289e5c953d8e4ed49e828dcc30f23"
  end

  keg_only :versioned_formula

  depends_on "go" => :build

  def install
    ENV["GOROOT_BOOTSTRAP"] = Formula["go"].opt_libexec

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

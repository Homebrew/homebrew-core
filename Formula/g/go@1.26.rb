class GoAT126 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.26.8.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.26.8.src.tar.gz"
  sha256 "4e39b98e42f946fa05ac8bc5b71877df97dbdb7cbb1a777b541667ad7117fd2e"
  license "BSD-3-Clause"
  compatibility_version 1

  livecheck do
    url "https://go.dev/dl/?mode=json"
    regex(/^go[._-]?v?(1\.26(?:\.\d+)*)[._-]src\.t.+$/i)
    strategy :json do |json, regex|
      json.map do |release|
        next if release["stable"] != true
        next if release["files"].none? { |file| file["filename"].match?(regex) }

        release["version"][/(\d+(?:\.\d+)+)/, 1]
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "924e4713369484b4f8854ebd0e8cf0e45dc1739f706123b8c7bc9191e018c7b5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "924e4713369484b4f8854ebd0e8cf0e45dc1739f706123b8c7bc9191e018c7b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "924e4713369484b4f8854ebd0e8cf0e45dc1739f706123b8c7bc9191e018c7b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "924e4713369484b4f8854ebd0e8cf0e45dc1739f706123b8c7bc9191e018c7b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8ef68e8708dc3ae3f512ac8b6505fb4a55ad36983f216dda8f1826156443b53e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "617d58e9160b78f861d996405fdb525b12c07bd0c6c7fa51417a94b2055793db"
  end

  keg_only :versioned_formula

  depends_on "go" => :build

  deny_network_access!

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

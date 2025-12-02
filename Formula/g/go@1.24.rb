class GoAT124 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.24.11.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.24.11.src.tar.gz"
  sha256 "ffdf97766a4c4b135cd53809713978e9ee1a943b2c8e28ad221a5429de30e210"
  license "BSD-3-Clause"

  livecheck do
    url "https://go.dev/dl/?mode=json"
    regex(/^go[._-]?v?(1\.24(?:\.\d+)*)[._-]src\.t.+$/i)
    strategy :json do |json, regex|
      json.map do |release|
        next if release["stable"] != true
        next if release["files"].none? { |file| file["filename"].match?(regex) }

        release["version"][/(\d+(?:\.\d+)+)/, 1]
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e8d78fb90d23b78e4c1f04792dfbf82a110f7ff3ac41947ad30ea6fdbf3f4ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e8d78fb90d23b78e4c1f04792dfbf82a110f7ff3ac41947ad30ea6fdbf3f4ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e8d78fb90d23b78e4c1f04792dfbf82a110f7ff3ac41947ad30ea6fdbf3f4ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "61840abb085af68d449c2be5ec58844cc39eba706b8d0e6d1855f9fed693a200"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f62cbe738445ae1ea57ad66c2ac4ae495a09a236bb8ea4b60fe221ded4af2616"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6383f8d884a09522f6dfea87d941d46ad2d6ca192f6e00165fe1e5435a991895"
  end

  keg_only :versioned_formula

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

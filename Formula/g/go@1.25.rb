class GoAT125 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.25.11.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.25.11.src.tar.gz"
  sha256 "7b4e5b079b3c9bc420373ca68621a296b4d13c10735d4acac4171928d70f5480"
  license "BSD-3-Clause"
  compatibility_version 3

  livecheck do
    url "https://go.dev/dl/?mode=json"
    regex(/^go[._-]?v?(1\.25(?:\.\d+)*)[._-]src\.t.+$/i)
    strategy :json do |json, regex|
      json.map do |release|
        next if release["stable"] != true
        next if release["files"].none? { |file| file["filename"].match?(regex) }

        release["version"][/(\d+(?:\.\d+)+)/, 1]
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6588e4b0bd71b2ebb339887f333fc3c91d519562fa210660bc2d563ca9170220"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6588e4b0bd71b2ebb339887f333fc3c91d519562fa210660bc2d563ca9170220"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6588e4b0bd71b2ebb339887f333fc3c91d519562fa210660bc2d563ca9170220"
    sha256 cellar: :any_skip_relocation, sonoma:        "1581cd772291b1af3016c1266dd9f8b5aabb509b01bb10bd5458ded6626e0691"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6803e69ad26891961f00cb259f15b25247d82b1a282d3899e8faf18305172ca4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddf6673eb05b77834f234f73984241b2e3ad8ebd1fe1252749cafa3e472bc5c3"
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

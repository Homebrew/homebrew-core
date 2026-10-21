class GoAT126 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.26.10.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.26.10.src.tar.gz"
  sha256 "fd63e883ba2f2bfca93c1646b31ebef63e2b1e4d2b317c9789d976a68d81f36f"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "099d8441c76253d9d3aa9c057597d4e9feaa4fa80826fbe96f56790ef590500e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "099d8441c76253d9d3aa9c057597d4e9feaa4fa80826fbe96f56790ef590500e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "099d8441c76253d9d3aa9c057597d4e9feaa4fa80826fbe96f56790ef590500e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5d80350a37fd860c05222ce884f57aefc381bcc4616172facc7f906efac1f2ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3cae21734bfa28285f480327b576138cb80c550ab20fbbe26a9c18e2484560a0"
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

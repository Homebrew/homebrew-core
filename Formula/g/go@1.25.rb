class GoAT125 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.25.10.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.25.10.src.tar.gz"
  sha256 "20cf04a92e5af99748e341bc8996fa28090c9ac98765fa115ec5ddf41d7af41d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23762c2874f952eb7a0c87979f6009f2ffd3819ab7fed20ab22c63cc3cc54174"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23762c2874f952eb7a0c87979f6009f2ffd3819ab7fed20ab22c63cc3cc54174"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23762c2874f952eb7a0c87979f6009f2ffd3819ab7fed20ab22c63cc3cc54174"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7c4f64a3b979bda3795eb9018d67102117e586d8f27d5b9763a2152e61a4b2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "975e35607cd98a8d7a6b65d98cd4eecbb93ff36f08324cf84cdfe6f2895bf75c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bec3052ad9ad1238b642b46bc8aa902311dbc96bd5a4a76175e13e9e2263ada"
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

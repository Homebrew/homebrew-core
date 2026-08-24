class GoAT126 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.26.7.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.26.7.src.tar.gz"
  sha256 "0ed24eac755105085b89fe9cabc2742b91a0ad7b94b59d3ad364918ebc8956ad"
  license "BSD-3-Clause"

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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62705ebc93775066169705c0134943012c877b71416a42b712c36852171a0e44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62705ebc93775066169705c0134943012c877b71416a42b712c36852171a0e44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62705ebc93775066169705c0134943012c877b71416a42b712c36852171a0e44"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b9f47b8d939814f371bb766863d885b027282be5648112d9218a4c9817bfc86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f7aad9c1f65d78de2bf225e8f50b28d4618944f68b12c815df69944c43691ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09811b13e0c63d7d9ab4b8eb8baf0218b61a9eafd109fe0802a700cf9405e01f"
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

class GoAT123 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.23.8.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.23.8.src.tar.gz"
  sha256 "0ca1f1e37ea255e3ce283af3f4e628502fb444587da987a5bb96d6c6f15930d4"
  license "BSD-3-Clause"

  livecheck do
    url "https://go.dev/dl/?mode=json"
    regex(/^go[._-]?v?(1\.23(?:\.\d+)*)[._-]src\.t.+$/i)
    strategy :json do |json, regex|
      json.map do |release|
        next if release["stable"] != true
        next if release["files"].none? { |file| file["filename"].match?(regex) }

        release["version"][/(\d+(?:\.\d+)+)/, 1]
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1c61ec0f6759a7cbba8ccd58ce776e520fc6342c317eaff1bfc191b9cbbf0db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1c61ec0f6759a7cbba8ccd58ce776e520fc6342c317eaff1bfc191b9cbbf0db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c1c61ec0f6759a7cbba8ccd58ce776e520fc6342c317eaff1bfc191b9cbbf0db"
    sha256 cellar: :any_skip_relocation, sonoma:        "7039ddf9427de2f02ee33963fa28ad920b116ac99c2f5b0003cd044b9eb779a3"
    sha256 cellar: :any_skip_relocation, ventura:       "7039ddf9427de2f02ee33963fa28ad920b116ac99c2f5b0003cd044b9eb779a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf3c7abd6007536cca37a09dbf62d08bd141c1f5b905ba3d8ba82a9b19e2b6ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dec1e5f00def83c22d0bb0b9503bfdf50ace2f655efdb2388c0d13b5ceb92ee7"
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
    with_env(CC: nil, CXX: nil) do
      assert_equal "Hello from cgo!\n", shell_output("#{bin}/go run hello_cgo.go")
    end
  end
end

class GoAT124 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.24.12.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.24.12.src.tar.gz"
  sha256 "fba2dd661b7be7b34d6bd17ed92f41c44a5e05953ad81ab34b4ec780e5e7dc41"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef06708b95e8f897dbe646e52a8adfadef06454b89186c26f7d29bd75d83d19a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef06708b95e8f897dbe646e52a8adfadef06454b89186c26f7d29bd75d83d19a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef06708b95e8f897dbe646e52a8adfadef06454b89186c26f7d29bd75d83d19a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d007b16926d701932e3643647f4a9966bb15c57cd7f38731b57c04545193710c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9a0a9e729d7920f7b49a27c0a2ce6471bc52b27b4c051cb0670789073422d50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7de30f8f4a68ad697761941f56162f1cdf291b497e991631f9d3f3acc2b45eb2"
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

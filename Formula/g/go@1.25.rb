class GoAT125 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.25.12.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.25.12.src.tar.gz"
  sha256 "f90dcee4bd023fa376374ea0a5a6ebe553537b39c426ffd8c689469b45519932"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42557a89b4d5fe4c34f3b697330835bebe204e84c68a39a45f3906d1afd436c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42557a89b4d5fe4c34f3b697330835bebe204e84c68a39a45f3906d1afd436c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42557a89b4d5fe4c34f3b697330835bebe204e84c68a39a45f3906d1afd436c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "45e7549e2c88cc5d5ae9f864520884f47223a34a949aee8e7e663c9f8bf7974e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "480349a3baedb8aaccfb39c0b60a130f8e59d6bf4f8fd4469da0a0edff3ea941"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cca31433764c48cee821c6add53d35c8f28ab15efa57762ba28f1bde3082158"
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

class GoAT125 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.25.9.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.25.9.src.tar.gz"
  sha256 "0ec9ef8ebcea097aac37decae9f09a7218b451cd96be7d6ed513d8e4bcf909cf"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3e030974b4b801a54590d37ba42e5d29ea79f0484a0f7d0b7be99f75dbca7bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3e030974b4b801a54590d37ba42e5d29ea79f0484a0f7d0b7be99f75dbca7bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3e030974b4b801a54590d37ba42e5d29ea79f0484a0f7d0b7be99f75dbca7bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "132bfea1dd4ef2fa54e663534869d5732ebde5122151545fedf000caa9f76cba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11a3e040bed69d32e9ef17e9ae20c03cb1381dbe326e75126a2e5e2d7aee19ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25dc6ae9aaf4817b0e681c444f850006659fad9ed0620fe77dd5903704c2956e"
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

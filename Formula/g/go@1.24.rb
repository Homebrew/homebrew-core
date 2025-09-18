class GoAT124 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.24.7.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.24.7.src.tar.gz"
  sha256 "2a8f50db0f88803607c50d7ea8834dcb7bd483c6b428a91e360fdf8624b46464"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99d7885acd026bc8bac68ae38bef84c3346d029b0fd267547fdcc5bfcd1b8d6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99d7885acd026bc8bac68ae38bef84c3346d029b0fd267547fdcc5bfcd1b8d6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99d7885acd026bc8bac68ae38bef84c3346d029b0fd267547fdcc5bfcd1b8d6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "99d7885acd026bc8bac68ae38bef84c3346d029b0fd267547fdcc5bfcd1b8d6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f9bb55fd2e9f0d4ad327a9417029d29375fe0e2abe2aeb2c347c24d0f5380ce"
    sha256 cellar: :any_skip_relocation, ventura:       "8f9bb55fd2e9f0d4ad327a9417029d29375fe0e2abe2aeb2c347c24d0f5380ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aeaaf56c0642e4389c212c27675eefa5143320ea0632346fb51bf46079c435ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "987f45c63d25f0c8978e957176e3452762b7e68e7519101ebba009ef80d806c5"
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

class GoAT123 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.23.11.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.23.11.src.tar.gz"
  sha256 "296381607a483a8a8667d7695331752f94a1f231c204e2527d2f22e1e3d1247d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40c7d7c251ac3deeb87dd69f98f9dd72bfffc668172d3a9c4cee310cab7e6199"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40c7d7c251ac3deeb87dd69f98f9dd72bfffc668172d3a9c4cee310cab7e6199"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "40c7d7c251ac3deeb87dd69f98f9dd72bfffc668172d3a9c4cee310cab7e6199"
    sha256 cellar: :any_skip_relocation, sonoma:        "31a7ed57a3c96afdd4ab85477344909279a6ca9a41a835b1da3644ad3535cab0"
    sha256 cellar: :any_skip_relocation, ventura:       "31a7ed57a3c96afdd4ab85477344909279a6ca9a41a835b1da3644ad3535cab0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "444534631cf0e666f6edf81bd787b1f6fb18571eb4595d37ded03e465d888a4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea77dc3f2dee9619526c96478e80fc3aae13143331cdf22fd34e1d6fde19f582"
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

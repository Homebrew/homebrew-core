class GoAT122 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.22.8.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.22.8.src.tar.gz"
  sha256 "df12c23ebf19dea0f4bf46a22cbeda4a3eca6f474f318390ce774974278440b8"
  license "BSD-3-Clause"

  livecheck do
    url "https://go.dev/dl/?mode=json"
    regex(/^go[._-]?v?(1\.22(?:\.\d+)*)[._-]src\.t.+$/i)
    strategy :json do |json, regex|
      json.map do |release|
        next if release["stable"] != true
        next if release["files"].none? { |file| file["filename"].match?(regex) }

        release["version"][/(\d+(?:\.\d+)+)/, 1]
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24d9692d879a7f2a28496fa4a56623d6923f165fc785bf34130540bba72f0552"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58c4d9b85f17e4cd3ff03ab7652651670cd18a07b6a0ba4e79f91ef0db152bf2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da3ea54d04ea72e184cfdc940e201a990e9f36f80d47f0ab06e2006d18242d08"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c7fa28d88bd76b0086ff372cb94a434a92c6f30b0702c53c9da990612f3cabc"
    sha256 cellar: :any_skip_relocation, ventura:       "ff03a1ddf0200c70de3957d4a39893125539bbcff541a7bf33bdbc64ea1baf31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b4548d936889c0d66cfcd50c21f4266c7da0a3afeadd21cb687cc1d0be7ae38"
  end

  keg_only :versioned_formula

  depends_on "go" => :build

  def install
    inreplace "go.env", /^GOTOOLCHAIN=.*$/, "GOTOOLCHAIN=local"

    cd "src" do
      ENV["GOROOT_FINAL"] = libexec
      # Set portable defaults for CC/CXX to be used by cgo
      with_env(CC: "cc", CXX: "c++") { system "./make.bash" }
    end

    libexec.install Dir["*"]
    bin.install_symlink Dir[libexec/"bin/go*"]

    system bin/"go", "install", "std", "cmd"

    # Remove useless files.
    # Breaks patchelf because folder contains weird debug/test files
    rm_r(libexec/"src/debug/elf/testdata")
    # Binaries built for an incompatible architecture
    rm_r(libexec/"src/runtime/pprof/testdata")
  end

  def caveats
    <<~EOS
      Homebrew's Go toolchain is configured with
        GOTOOLCHAIN=local
      per Homebrew policy on tools that update themselves.
    EOS
  end

  test do
    assert_equal "local", shell_output("#{bin}/go env GOTOOLCHAIN").strip

    (testpath/"hello.go").write <<~EOS
      package main

      import "fmt"

      func main() {
          fmt.Println("Hello World")
      }
    EOS

    # Run go fmt check for no errors then run the program.
    # This is a a bare minimum of go working as it uses fmt, build, and run.
    system bin/"go", "fmt", "hello.go"
    assert_equal "Hello World\n", shell_output("#{bin}/go run hello.go")

    with_env(GOOS: "freebsd", GOARCH: "amd64") do
      system bin/"go", "build", "hello.go"
    end

    (testpath/"hello_cgo.go").write <<~EOS
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
    EOS

    # Try running a sample using cgo without CC or CXX set to ensure that the
    # toolchain's default choice of compilers work
    with_env(CC: nil, CXX: nil) do
      assert_equal "Hello from cgo!\n", shell_output("#{bin}/go run hello_cgo.go")
    end
  end
end

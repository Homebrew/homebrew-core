class GoAT125 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.25.8.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.25.8.src.tar.gz"
  sha256 "e988d4a2446ac7fe3f6daa089a58e9936a52a381355adec1c8983230a8d6c59e"
  license "BSD-3-Clause"
  compatibility_version 2

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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bda08a2cddf994cf92e7c4a1c4c770f44e6f51efae590d495808967f40b23461"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bda08a2cddf994cf92e7c4a1c4c770f44e6f51efae590d495808967f40b23461"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bda08a2cddf994cf92e7c4a1c4c770f44e6f51efae590d495808967f40b23461"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ae4e6dccc6e85670d2b39d55f67c06a4864d459beeb97205c9358a025d060d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53732bc4fea3a55f4cf8707c0b604538c67988462b065720686db70b07773acc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1605aa27d1632b7875c3a7cbd21e8131c956c29162d206321353b122eeee2fb4"
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

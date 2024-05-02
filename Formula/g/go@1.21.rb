class GoAT121 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.21.9.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.21.9.src.tar.gz"
  sha256 "58f0c5ced45a0012bce2ff7a9df03e128abcc8818ebabe5027bb92bafe20e421"
  license "BSD-3-Clause"

  livecheck do
    url "https://go.dev/dl/?mode=json"
    regex(/^go[._-]?v?(1\.21(?:\.\d+)*)[._-]src\.t.+$/i)
    strategy :json do |json, regex|
      json.map do |release|
        next if release["stable"] != true
        next if release["files"].none? { |file| file["filename"].match?(regex) }

        release["version"][/(\d+(?:\.\d+)+)/, 1]
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6697373eb3f827ae6be663bef4d8e40fb77ba5444bd2750758034b2455c0e112"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b7bb33890a2c95fe872c08a0a7d703ac026bd64e0351057c768999327bebdbd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e453fd4a64a3a327bb0af1ff248c182c4e86590ef5bbc45291fccaed36af2c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "21ff92f9139c9c208d59d075f924423cc074099029600e4a3eb0d614e7b4d708"
    sha256 cellar: :any_skip_relocation, ventura:        "6c56bde935c96314882e083fd91b0258195b70f6e503c7b08339261727441e9d"
    sha256 cellar: :any_skip_relocation, monterey:       "45935bf32c74bbd6194746c8cf17fd203019c67fa89569b688b92571809cba3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9ac5dc39a1a6db538b819b81d33bbe37cc6617211de4b4b9c64d9e42ef07bc2"
  end

  keg_only :versioned_formula

  depends_on "go" => :build

  def install
    ENV["GOROOT_BOOTSTRAP"] = buildpath/"gobootstrap"

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
    (libexec/"src/debug/elf/testdata").rmtree
    # Binaries built for an incompatible architecture
    (libexec/"src/runtime/pprof/testdata").rmtree
  end

  test do
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

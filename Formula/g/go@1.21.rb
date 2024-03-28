class GoAT121 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.21.8.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.21.8.src.tar.gz"
  sha256 "dc806cf75a87e1414b5b4c3dcb9dd3e9cc98f4cfccec42b7af617d5a658a3c43"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "086fd0c47f5886d1e6375b7491b9741f703cc86140f5f2d22414ac6d46115781"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4899ec04a358067ca6c7c0fce6090df55bbc755c29b0e7d05db7ee5f54664c22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ddcfa2dc14942a3a7aafa2b22def3799b4b2a1d7cf3e6f5c82195afc6cd83d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "802883c4a6a7569eb09ad19c27ed449b091766a1738bd12597a810ae2ef72014"
    sha256 cellar: :any_skip_relocation, ventura:        "696e8ee947d4ddd035827f8a4c607a09877cb683414f98211a476ebebc20c129"
    sha256 cellar: :any_skip_relocation, monterey:       "cdc6761821cb4ed47b1fe6f74042af3250495eb6ee00871fedc9d5516442bd6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2ed8bbd49ba88b66e5150fbe47b55244a212d39b2550f25a44d9ed2f73384d7"
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

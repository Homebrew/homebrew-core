class GoAT122 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.22.11.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.22.11.src.tar.gz"
  sha256 "a60c23dec95d10a2576265ce580f57869d5ac2471c4f4aca805addc9ea0fc9fe"
  license "BSD-3-Clause"
  revision 1

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
    sha256 arm64_sequoia: "bf4bb48caf0fd288afd7fef5221494383054e7760900c54cb3a72c7cfd518d5e"
    sha256 arm64_sonoma:  "f88650d91eadc4c714dc722de9011b08d9bc30d2f53c9ceb7cef355927232025"
    sha256 arm64_ventura: "efce25229471aa84fda3cc92b5f0a13f3f1d5269a6b87f08969f3ec93818beda"
    sha256 sonoma:        "9970ec125b2b0ccbdbecc3855538d60070d1e75dd0835185999d22b297dc71b9"
    sha256 ventura:       "58bc476df5596177562958ab9419ee0ffefa4b59be39af47e6437ff5ce48665e"
    sha256 x86_64_linux:  "070f65df59f86b5bd6b8d40183c0574c443e12dc133c8b0ea8cba0fd1d52c3c1"
  end

  keg_only :versioned_formula

  depends_on "go" => :build

  def install
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

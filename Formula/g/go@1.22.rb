class GoAT122 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.22.9.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.22.9.src.tar.gz"
  sha256 "e81a362f51aee2125722b018e46714e6a055a1954283414c0f937e737013db22"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "985b6fb1f6492383c99e19d95b33d12e6d221987f17098ff3537e724c62e395f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c09d53e4d01f9498120d18ae866304547b4ca6abadf250e337a993499b9bd13"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ea3e4773f62f3db051806fd5d8aac169e5af9b3e9e9c4b3d99b401b65df915d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc92d8991effaeb1052fab4776c3d97d925a5875a7cd6e8e6a80c3fd2cd38808"
    sha256 cellar: :any_skip_relocation, ventura:       "bf3bbc9a6a8d61268f68f8023235320920a247a5a6d0b4b78a3f4653fd187da1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7b7a3d72702cd20ea9cd94562f0e8c9d84109255602e01038b5833716b17f67"
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

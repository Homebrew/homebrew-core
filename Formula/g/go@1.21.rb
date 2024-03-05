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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cfe245a2483f2986df1305b8ccadbd9a33176933cf71d360d9079103cfd8651f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "360120c736272b25010efeb1684f212057c0c56b1db7cc9ab273e4b87464c1f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb0c8414d244df0cbf9aca747002e9fbd908cc30fb019839ba8bdfd965bd3a8b"
    sha256 cellar: :any_skip_relocation, sonoma:         "13aa849e8344b3ed0598ec2709b9e73ff98c6c1db33134f52926173faff8a221"
    sha256 cellar: :any_skip_relocation, ventura:        "990ce429d7e4bb12b7410b3147368dc32cdb5947d6e9ebe332c234304f4c2845"
    sha256 cellar: :any_skip_relocation, monterey:       "d76c1beca68fcc21d9b0434e208078d923554137f8f197f37da6398467aa9a11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50267ed8784b1b53421be15ef39efdd6d039ce9dff5d5854c63149988c636c04"
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

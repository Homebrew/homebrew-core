class GoAT121 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.21.11.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.21.11.src.tar.gz"
  sha256 "42aee9bf2b6956c75a7ad6aa3f0a51b5821ffeac57f5a2e733a2d6eae1e6d9d2"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee4d82ba61125bf04623911c489dc6a3f8c43b9ac7f97fb05b796522a6707c57"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11d413d94b5e7f17164135fc15fab46e7184d8c3f8072f186eec2d90a1b82596"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "067bb2d157d50c3ede9ce28c08edd7e5b9cc542c2c1bf5b55e94b44803163ce3"
    sha256 cellar: :any_skip_relocation, sonoma:         "774b20be72b7723a6792059577b4d8e40cfa73ee40d01308fe37db75e7a74f21"
    sha256 cellar: :any_skip_relocation, ventura:        "72ffae8533d58fc43869b2aa69397c4ead8a96abd440130a8172b81471f2bb9f"
    sha256 cellar: :any_skip_relocation, monterey:       "dc2d3f9a9905a4880bac149527057fce4a05ec226c08680a01032fde4b369c2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20a0fc8da4f3a8e5aa10c5bd14a06c3cee2e0b791c3d684aaa33df3afece80be"
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

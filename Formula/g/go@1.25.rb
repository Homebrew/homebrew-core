class GoAT125 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.25.7.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.25.7.src.tar.gz"
  sha256 "178f2832820274b43e177d32f06a3ebb0129e427dd20a5e4c88df2c1763cf10a"
  license "BSD-3-Clause"
  revision 1
  compatibility_version 1

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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b7dbdf302ac420aa8f9f21b80753b42670160344ae8fcd222ed79f5dc4daa55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b7dbdf302ac420aa8f9f21b80753b42670160344ae8fcd222ed79f5dc4daa55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b7dbdf302ac420aa8f9f21b80753b42670160344ae8fcd222ed79f5dc4daa55"
    sha256 cellar: :any_skip_relocation, sonoma:        "22393319dcfebad92b53a89259e924f66c7fec7bf56d73f8dd5be88c0e75cb4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df5032811d797828f11621cdf085d5ab39fafa1127299c95d321773920257de8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88ee33ff7f5018e16c12a93d4bad41ecfb5ed6b7112cd7a0206b6d69684552e0"
  end

  keg_only :versioned_formula

  depends_on "go" => :build

  # patch to fix pkg-config flag sanitization
  # Backport issue https://golang.org/issue/77438, should be included in 1.25.8+.
  patch do
    url "https://github.com/golang/go/commit/28fbdf7acb4146b5bc3d88128e407d1344691839.patch?full_index=1"
    sha256 "2e05f7e16f2320685547a7ebb240163a8b7f1c7bf9d2f6dc4872ff8b27707a35"
  end

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

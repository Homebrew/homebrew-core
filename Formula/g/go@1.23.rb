class GoAT123 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.23.9.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.23.9.src.tar.gz"
  sha256 "08f6419547563ed9e7037d12b9c8909677c72f75f62ef85887ed9dbf49b8d2dd"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23a76f710a0e56368df1c72b3460ed9e300f732994f180d7a2b00f6f3fd703bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23a76f710a0e56368df1c72b3460ed9e300f732994f180d7a2b00f6f3fd703bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "23a76f710a0e56368df1c72b3460ed9e300f732994f180d7a2b00f6f3fd703bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "2350282b5e3ef4aab23f0863982456baaf489ac542dfb390191c943faaf4d743"
    sha256 cellar: :any_skip_relocation, ventura:       "2350282b5e3ef4aab23f0863982456baaf489ac542dfb390191c943faaf4d743"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbeb49636916d580298cb2a8f7bb85f0e9cb05a25e54ff6ddf6400001579fa68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bb31a723e39f2284faeaf355fee1dae6fdf2212235e680c83f5e0f8aff562de"
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

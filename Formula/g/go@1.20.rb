class GoAT120 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.20.14.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.20.14.src.tar.gz"
  sha256 "1aef321a0e3e38b7e91d2d7eb64040666cabdcc77d383de3c9522d0d69b67f4e"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6fa23aea0aeed267195266f0242cd459f5027339d5485aa6eae3073736608e4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b7719f9f65d0176b3016a973a9c9ee179ed204465670f550aea36878335e644"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b7719f9f65d0176b3016a973a9c9ee179ed204465670f550aea36878335e644"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b7719f9f65d0176b3016a973a9c9ee179ed204465670f550aea36878335e644"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6931aff2c86cf18137b5c5b01dd2a842c8660a24724bb02a7880a95fc3590e4"
    sha256 cellar: :any_skip_relocation, ventura:        "b6931aff2c86cf18137b5c5b01dd2a842c8660a24724bb02a7880a95fc3590e4"
    sha256 cellar: :any_skip_relocation, monterey:       "b6931aff2c86cf18137b5c5b01dd2a842c8660a24724bb02a7880a95fc3590e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf015c4d4657340f494946062e329277dba2f466ea0fce812186614f36b78561"
  end

  keg_only :versioned_formula

  # EOL with Go 1.22 release (2024-02-06)
  # Ref: https://go.dev/doc/devel/release#policy
  deprecate! date: "2024-02-14", because: :unsupported
  disable! date: "2025-02-19", because: :unsupported

  depends_on "go" => :build

  def install
    ENV["GOROOT_BOOTSTRAP"] = Formula["go"].opt_libexec

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

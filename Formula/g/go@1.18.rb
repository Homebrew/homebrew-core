class GoAT118 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.18.10.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.18.10.src.tar.gz"
  sha256 "9cedcca58845df0c9474ae00274c44a95c9dfaefb132fc59921c28c7c106f8e6"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f194ab657154716284ed3d32fb67a828eca45d5f5f91c9529621e2e94e9adc29"
    sha256                               arm64_ventura:  "15289dd579551ed629bda489e6ba7fb0d641d8ef468d6ed62a9fde136fd8406f"
    sha256                               arm64_monterey: "fb4e5c1a52261198a393492baa2a44983fccfc4f2917dde8c0509f13d0e27450"
    sha256                               arm64_big_sur:  "5873d1892e88cbedcbf289b9898c283ebcc8d0f1dd3dabf2f748f25a8a8e1a8f"
    sha256 cellar: :any_skip_relocation, sonoma:         "22605929d371c0ff157e42601233754de3d922be9004b799e27f1cafc535120f"
    sha256                               ventura:        "98e567fe4e5dfbd80a95c983bb851ee69d0cb15b7097966993e2e45a4c065489"
    sha256                               monterey:       "9d842f4470cd8aa9962447cab57f511e0b45faca9ccdd84ecdf6c859567689af"
    sha256                               big_sur:        "668e852707a63dbf4db3a240089baaa20dd239772e80f65ec5bb152afb7184b3"
    sha256                               x86_64_linux:   "cc61c960b7186af57e6cc1d1f9a82beace7a93523784d78a177429d1944aa5eb"
  end

  keg_only :versioned_formula

  # EOL with Go 1.20 release (2023-02-01)
  # Ref: https://go.dev/doc/devel/release#policy
  disable! date: "2024-02-12", because: :unsupported

  depends_on "go" => :build

  def install
    ENV["GOROOT_BOOTSTRAP"] = Formula["go"].opt_libexec

    cd "src" do
      ENV["GOROOT_FINAL"] = libexec
      system "./make.bash", "--no-clean"
    end

    rm_r(buildpath/"pkg/obj")
    libexec.install Dir["*"]
    bin.install_symlink Dir[libexec/"bin/go*"]

    system bin/"go", "install", "-race", "std"

    # Remove useless files.
    # Breaks patchelf because folder contains weird debug/test files
    rm_r(libexec/"src/debug/elf/testdata")
    # Binaries built for an incompatible architecture
    rm_r(libexec/"src/runtime/pprof/testdata")
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

    ENV["GOOS"] = "freebsd"
    ENV["GOARCH"] = "amd64"
    system bin/"go", "build", "hello.go"
  end
end

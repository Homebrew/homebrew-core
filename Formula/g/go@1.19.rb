class GoAT119 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.19.13.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.19.13.src.tar.gz"
  sha256 "ccf36b53fb0024a017353c3ddb22c1f00bc7a8073c6aac79042da24ee34434d3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32c7123bcc814d8ed1f54c072ab06e4128f82378feee8a3fa78e8475ceb5b55a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf10aa203445ad09fcb6e97e91ee75cb41215b3d9b84e1c25e6e24ba45454dbc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff3535b243ddf16a1176b0d4ac28758c62f779622e1b026f24cfa4bee6cb7546"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c65c8386347f9ba16fd7579f8757c8e9ee663126cf1eb01202b9755bf409a6d"
    sha256 cellar: :any_skip_relocation, sonoma:         "c6c642417aa9afcae02b508edbd943d8fad594d156f5d215e75ad45682d3376d"
    sha256 cellar: :any_skip_relocation, ventura:        "65b21f9af59dcf256e92b050f53be5045ab2e2b1d24ba78896314ce9f982e31c"
    sha256 cellar: :any_skip_relocation, monterey:       "3637554cb731fa4f70289bf2b41c5474de93354f4d1712c16f30b2d3d450c323"
    sha256 cellar: :any_skip_relocation, big_sur:        "acb41f7e734a1302f73d2ea998052aa82e523a4285270f12417fa02f5b2ce30e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25d23ef810a777c73e48f84ab03c7dd161d5b7706d31010f7ab3b0d595ec13f8"
  end

  keg_only :versioned_formula

  # EOL with Go 1.21 release (2023-08-08)
  # Ref: https://go.dev/doc/devel/release#policy
  disable! date: "2024-08-24", because: :unsupported

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

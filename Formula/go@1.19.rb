class GoAT119 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.19.8.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.19.8.src.tar.gz"
  sha256 "1d7a67929dccafeaf8a29e55985bc2b789e0499cb1a17100039f084e3238da2f"
  license "BSD-3-Clause"

  livecheck do
    url "https://go.dev/dl/"
    regex(/href=.*?go[._-]?v?(1\.19(?:\.\d+)*)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba379c73d3a29b6e29ddba23a378650f9a1e53af58adf0f704013e3733461b91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c67f18a1e1488fee98fb1403c90c9ead935696737ca3f54b089a01adbac3385c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "313ce10eed6843963d860a3e668cc9d7d8c994921f2575f5ffc5e51dbe47fa2c"
    sha256 cellar: :any_skip_relocation, ventura:        "73a6ce2ebe92780950d2e7f84bac870c6a38fe7a49708d3a7aab610b7832dc80"
    sha256 cellar: :any_skip_relocation, monterey:       "52120e29f83c9e0634383e7cc03e2243c65851d6841148a85557d95901984aa6"
    sha256 cellar: :any_skip_relocation, big_sur:        "39f12d34fe7667476b28139a4ad1a79920eb33468196b6c3a178c0e212a72a6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d82edfbe59a7f589e3373fd3ce8d0e68142ac56c0191d454d7a6084ecc216542"
  end

  keg_only :versioned_formula

  depends_on "go" => :build

  def install
    ENV["GOROOT_BOOTSTRAP"] = Formula["go"].opt_libexec

    cd "src" do
      ENV["GOROOT_FINAL"] = libexec
      system "./make.bash", "--no-clean"
    end

    (buildpath/"pkg/obj").rmtree
    libexec.install Dir["*"]
    bin.install_symlink Dir[libexec/"bin/go*"]

    system bin/"go", "install", "-race", "std"

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

    ENV["GOOS"] = "freebsd"
    ENV["GOARCH"] = "amd64"
    system bin/"go", "build", "hello.go"
  end
end

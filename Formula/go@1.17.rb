class GoAT117 < Formula
  desc "Go programming environment (1.17)"
  homepage "https://golang.org"
  url "https://go.dev/dl/go1.17.13.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.17.13.src.tar.gz"
  sha256 "a1a48b23afb206f95e7bbaa9b898d965f90826f6f1d1fc0c1d784ada0cd300fd"
  license "BSD-3-Clause"

  livecheck do
    url "https://golang.org/dl/"
    regex(/href=.*?go[._-]?v?(1\.17(?:\.\d+)*)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea6bf463fa3ccf337f7603dacf55e6aa802b992b018a2f02cdbd6f888cf986f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1615510e28c108a3793d14da975e1553175b455d315e89ba1d40a6a1379aee6e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a89848112b03e93b55963c98291990b1e8e0e5156a8c8b25210fee9296cebf8c"
    sha256 cellar: :any_skip_relocation, ventura:        "9ee08494e55609d8ec2f6cc6e86c9648ca34b3409a365ada7268e321a950ef7b"
    sha256 cellar: :any_skip_relocation, monterey:       "b67539ffcfcd8d21d08bbcc8122eca9ee447aeeec1f69ea186b14196b5a9f208"
    sha256 cellar: :any_skip_relocation, big_sur:        "f175e7d545df1fd9166d6cdfda5a2a707f9fcb816a9759fa8c75a7db11b4c3b8"
    sha256 cellar: :any_skip_relocation, catalina:       "086b1fb9f0565cc361ac4f64283a86df7d8de77ff61ecca36082bbd1665914cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae8069616fb2fdbade309d51ef420e3e6c04f9df6a23d4d63178be0ef4bdb640"
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
    ENV["GOARCH"] = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    system bin/"go", "build", "hello.go"
  end
end

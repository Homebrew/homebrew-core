class GoAT116 < Formula
  desc "Go programming environment (1.16)"
  homepage "https://golang.org"
  url "https://golang.org/dl/go1.16.13.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.16.13.src.tar.gz"
  sha256 "b0926654eaeb01ef43816638f42d7b1681f2d3f41b9559f07735522b7afad41a"
  license "BSD-3-Clause"

  livecheck do
    url "https://golang.org/dl/"
    regex(/href=.*?go[._-]?v?(1\.16(?:\.\d+)*)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09af063f683ccd3229c5220dd9b01cf9045edcd1ce4fee0ed38fa0349782a23a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a099f8e0180858b152cf240cd085a3cc28697446cb689d250126fbb6a35d8663"
    sha256 cellar: :any_skip_relocation, monterey:       "05513e449f4f34bfde72cf455b38a786487f239b5a1bbb45055199d5a206d8da"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd2d3d7e50ae392186f65ceb5e604c1beb269883a578ec7b1c3266854ae95dd5"
    sha256 cellar: :any_skip_relocation, catalina:       "13f9cba2fa3c89b49cd1a38e0e234be10b4d8928d50a66501c82e10e68e277e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f09c23e687156fe18aa903f174f476ead4e95e272cd73228de69c1ba4c40131"
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

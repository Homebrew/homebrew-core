class GoAT116 < Formula
  desc "Go programming environment (1.16)"
  homepage "https://golang.org"
  url "https://golang.org/dl/go1.16.15.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.16.15.src.tar.gz"
  sha256 "90a08c689279e35f3865ba510998c33a63255c36089b3ec206c912fc0568c3d3"
  license "BSD-3-Clause"

  livecheck do
    url "https://golang.org/dl/"
    regex(/href=.*?go[._-]?v?(1\.16(?:\.\d+)*)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0500786661f7cddfc20403a9daa9af648404e0564363783fb7d9fc44e884fe3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5dcd84f44f1231cf1d32cbe6ca5d5f158de11efe7ea24b1ae24b4ede68cc6361"
    sha256 cellar: :any_skip_relocation, monterey:       "b57fe6d2c36ea1529189bd3b7c9687a17c5b66660843f8f8db80b3a437693743"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ba14df4f397d33f51bc22b9da40f07836990e6eb2e876aba96f3da82e12babe"
    sha256 cellar: :any_skip_relocation, catalina:       "80d62cf6ed5b2fedfd714b1f02e7bb660a23d6f061f7ecdfdbbdf0257072401f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aaee729abff3f20350c5af642bea0e39257fe077dde752873f8539fbfed874d9"
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

class GoAT120 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.20.8.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.20.8.src.tar.gz"
  sha256 "38d71714fa5279f97240451956d8e47e3c1b6a5de7cb84137949d62b5dd3182e"
  license "BSD-3-Clause"

  livecheck do
    url "https://go.dev/dl/"
    regex(/href=.*?go[._-]?v?(1\.20(?:\.\d+)*)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e973e81b3ccb33f0a5f0aa5ec22a510422aa579cb57e57e7b11aca3bf995ca9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e973e81b3ccb33f0a5f0aa5ec22a510422aa579cb57e57e7b11aca3bf995ca9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e973e81b3ccb33f0a5f0aa5ec22a510422aa579cb57e57e7b11aca3bf995ca9a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e973e81b3ccb33f0a5f0aa5ec22a510422aa579cb57e57e7b11aca3bf995ca9a"
    sha256 cellar: :any_skip_relocation, sonoma:         "c19e7417c20997a8bdd347fbf8ee4a1535fe5ca5e3a91827fe496022d46d67d1"
    sha256 cellar: :any_skip_relocation, ventura:        "c19e7417c20997a8bdd347fbf8ee4a1535fe5ca5e3a91827fe496022d46d67d1"
    sha256 cellar: :any_skip_relocation, monterey:       "c19e7417c20997a8bdd347fbf8ee4a1535fe5ca5e3a91827fe496022d46d67d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "c19e7417c20997a8bdd347fbf8ee4a1535fe5ca5e3a91827fe496022d46d67d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "804a3870fa790ff14422f9abacc4569386eecc636160c90c7a3443162a607aea"
  end

  keg_only :versioned_formula

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

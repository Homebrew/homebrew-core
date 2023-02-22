class GoAT118 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.18.10.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.18.10.src.tar.gz"
  sha256 "9cedcca58845df0c9474ae00274c44a95c9dfaefb132fc59921c28c7c106f8e6"
  license "BSD-3-Clause"

  livecheck do
    url "https://go.dev/dl/"
    regex(/href=.*?go[._-]?v?(1\.18(?:\.\d+)*)[._-]src\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "15289dd579551ed629bda489e6ba7fb0d641d8ef468d6ed62a9fde136fd8406f"
    sha256 arm64_monterey: "fb4e5c1a52261198a393492baa2a44983fccfc4f2917dde8c0509f13d0e27450"
    sha256 arm64_big_sur:  "5873d1892e88cbedcbf289b9898c283ebcc8d0f1dd3dabf2f748f25a8a8e1a8f"
    sha256 ventura:        "98e567fe4e5dfbd80a95c983bb851ee69d0cb15b7097966993e2e45a4c065489"
    sha256 monterey:       "9d842f4470cd8aa9962447cab57f511e0b45faca9ccdd84ecdf6c859567689af"
    sha256 big_sur:        "668e852707a63dbf4db3a240089baaa20dd239772e80f65ec5bb152afb7184b3"
    sha256 x86_64_linux:   "cc61c960b7186af57e6cc1d1f9a82beace7a93523784d78a177429d1944aa5eb"
  end

  keg_only :versioned_formula

  # EOL with Go 1.20 release (2023-02-01)
  # Ref: https://go.dev/doc/devel/release#policy
  deprecate! date: "2023-02-21", because: :unsupported

  # Don't update this unless this version cannot bootstrap the new version.
  resource "gobootstrap" do
    checksums = {
      "darwin-arm64" => "4dac57c00168d30bbd02d95131d5de9ca88e04f2c5a29a404576f30ae9b54810",
      "darwin-amd64" => "6000a9522975d116bf76044967d7e69e04e982e9625330d9a539a8b45395f9a8",
      "linux-arm64"  => "3770f7eb22d05e25fbee8fb53c2a4e897da043eb83c69b9a14f8d98562cd8098",
      "linux-amd64"  => "013a489ebb3e24ef3d915abe5b94c3286c070dfe0818d5bca8108f1d6e8440d2",
    }

    arch = "arm64"
    platform = "darwin"

    on_intel do
      arch = "amd64"
    end

    on_linux do
      platform = "linux"
    end

    boot_version = "1.16"

    url "https://storage.googleapis.com/golang/go#{boot_version}.#{platform}-#{arch}.tar.gz"
    version boot_version
    sha256 checksums["#{platform}-#{arch}"]
  end

  def install
    (buildpath/"gobootstrap").install resource("gobootstrap")
    ENV["GOROOT_BOOTSTRAP"] = buildpath/"gobootstrap"

    cd "src" do
      ENV["GOROOT_FINAL"] = libexec
      system "./make.bash", "--no-clean"
    end

    (buildpath/"pkg/obj").rmtree
    rm_rf "gobootstrap" # Bootstrap not required beyond compile.
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

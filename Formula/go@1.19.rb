class GoAT119 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.19.10.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.19.10.src.tar.gz"
  sha256 "13755bcce529747d5f2930dee034730c86d02bd3e521ab3e2bbede548d3b953f"
  license "BSD-3-Clause"

  livecheck do
    url "https://go.dev/dl/"
    regex(/href=.*?go[._-]?v?(1\.19(?:\.\d+)*)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89550534e0da6b164f081424a5cf5d2a2a795886fb6eef94bcb6f627571bb551"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba044582e0d8c3caa3ed66de27d77ef41b5f055a5c381b1b1ba0ef67fddc41f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "617333656d4b6cf4e3569faf257d38172aed67d1b43022be3ec2e20ec8012cc7"
    sha256 cellar: :any_skip_relocation, ventura:        "2c25de867609bc1569d173403601197623b035c963c8bb6eac2bd2e7aa36d397"
    sha256 cellar: :any_skip_relocation, monterey:       "51850b0f9e05d0adc0a3b2e93357a641ff7f362767f769771f5f8d80a4f36af2"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad707b09b7c39228f710dd4499610d066d007088e534b98ea6cbb3b97613fb29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c667083d40d6815e75d840b72398167f452160bfc0b9e7567ccad2048ad864ef"
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

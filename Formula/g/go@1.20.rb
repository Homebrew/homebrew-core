class GoAT120 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.20.9.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.20.9.src.tar.gz"
  sha256 "4923920381cd71d68b527761afefa523ea18c5831b4795034c827e18b685cdcf"
  license "BSD-3-Clause"

  livecheck do
    url "https://go.dev/dl/?mode=json"
    regex(/^go[._-]?v?(1\.20(?:\.\d+)*)[._-]src\.t.+$/i)
    strategy :json do |json, regex|
      json.map do |release|
        next if release["stable"] != true
        next if release["files"].none? { |file| file["filename"].match?(regex) }

        release["version"][/(\d+(?:\.\d+)+)/, 1]
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ddc75fec286edec617abbc416c29cc488e5234cdf91e78ed618c7328e91c7c78"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ddc75fec286edec617abbc416c29cc488e5234cdf91e78ed618c7328e91c7c78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ddc75fec286edec617abbc416c29cc488e5234cdf91e78ed618c7328e91c7c78"
    sha256 cellar: :any_skip_relocation, sonoma:         "250b39a42425273be32ec5e131c607a340ead6c12572f91f5abcfd9b2bb5110f"
    sha256 cellar: :any_skip_relocation, ventura:        "250b39a42425273be32ec5e131c607a340ead6c12572f91f5abcfd9b2bb5110f"
    sha256 cellar: :any_skip_relocation, monterey:       "250b39a42425273be32ec5e131c607a340ead6c12572f91f5abcfd9b2bb5110f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df15e67ba2ab77b685d24657ab601876382762cb0397d9302b98772ec5ce43ba"
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

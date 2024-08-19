class GoAT122 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.22.6.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.22.6.src.tar.gz"
  sha256 "9e48d99d519882579917d8189c17e98c373ce25abaebb98772e2927088992a51"
  license "BSD-3-Clause"

  livecheck do
    url "https://go.dev/dl/?mode=json"
    regex(/^go[._-]?v?(1\.22(?:\.\d+)*)[._-]src\.t.+$/i)
    strategy :json do |json, regex|
      json.map do |release|
        next if release["stable"] != true
        next if release["files"].none? { |file| file["filename"].match?(regex) }

        release["version"][/(\d+(?:\.\d+)+)/, 1]
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68aabbf7b2ba87f0bd6892152ca9aa0d3dd10f1bd25344ee1037ec29bdb3f936"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73ba6426013ef441b6e9cd0872836eb7ea464a2d8f9fea3984110616781b2f0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef89ae87cd0ed55b0fd381f8bbcb42b7c52eed6e54972596d1bb1b72d89131c4"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e68373a840d6d26569dbc554a4650a1a3904b5b153a0a4acc43d0d3e3878e87"
    sha256 cellar: :any_skip_relocation, ventura:        "32e9a0e9537eba8c2377a85e1bc57939e0e03847ad681b43d35d55eba58c8d82"
    sha256 cellar: :any_skip_relocation, monterey:       "8291e28b058d302c2f2d0ac84003601e56fe510e938da0de9adc78e6ee0fcfcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51a51b57cd732a2a013fd0126944d6de705ee28110a9946ca10df2f862f967d2"
  end

  keg_only :versioned_formula

  depends_on "go" => :build

  def install
    ENV["GOROOT_BOOTSTRAP"] = buildpath/"gobootstrap"

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

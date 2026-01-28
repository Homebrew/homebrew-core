class Go < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.26rc2.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.26rc2.src.tar.gz"
  sha256 "e25cc8c5ffe1241a5d87199209243d70c24847260fb1ea7b163a95b537de65ac"
  license "BSD-3-Clause"
  head "https://go.googlesource.com/go.git", branch: "master"

  livecheck do
    url "https://go.dev/dl/?mode=json"
    regex(/^go[._-]?v?(\d+(?:\.\d+)+)[._-]src\.t.+$/i)
    strategy :json do |json, regex|
      json.map do |release|
        next if release["stable"] != true
        next if release["files"].none? { |file| file["filename"].match?(regex) }

        release["version"][/(\d+(?:\.\d+)+)/, 1]
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a367c20ea5e73fb63c8448a476693273c03cc8c184acab8daedaa4c20f6c7c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a367c20ea5e73fb63c8448a476693273c03cc8c184acab8daedaa4c20f6c7c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a367c20ea5e73fb63c8448a476693273c03cc8c184acab8daedaa4c20f6c7c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "b58eec9e49e5c7f71b80c9ed6f949fd68474c6cf92deb75b7dde2d94d4e872a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49d7d612a620aece265ba66d0e9cfe0bc76e418b412cf9e08af2c6f52e0b64f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ae958e52552439be1b5d86041dfbfe929c0b3e22f24aa331af7890665462ddd"
  end

  depends_on macos: :monterey

  # Don't update this unless this version cannot bootstrap the new version.
  resource "gobootstrap" do
    checksums = {
      "darwin-arm64" => "098d0c039357c3652ec6c97d5451bc4dc24f7cf30ed902373ed9a8134aab2d29",
      "darwin-amd64" => "4b9cc6771b56645da35a83a5424ae507f3250829b0d227e75f57b73e72da1f76",
      "linux-arm64"  => "4e02e2979e53b40f3666bba9f7e5ea0b99ea5156e0824b343fd054742c25498d",
      "linux-amd64"  => "bddf8e653c82429aea7aec2520774e79925d4bb929fe20e67ecc00dd5af44c50",
    }

    version "1.24.12"

    on_arm do
      on_macos do
        url "https://go.dev/dl/go#{version}.darwin-arm64.tar.gz"
        sha256 checksums["darwin-arm64"]
      end
      on_linux do
        url "https://go.dev/dl/go#{version}.linux-arm64.tar.gz"
        sha256 checksums["linux-arm64"]
      end
    end
    on_intel do
      on_macos do
        url "https://go.dev/dl/go#{version}.darwin-amd64.tar.gz"
        sha256 checksums["darwin-amd64"]
      end
      on_linux do
        url "https://go.dev/dl/go#{version}.linux-amd64.tar.gz"
        sha256 checksums["linux-amd64"]
      end
    end
  end

  def install
    libexec.install Dir["*"]
    (buildpath/"gobootstrap").install resource("gobootstrap")
    ENV["GOROOT_BOOTSTRAP"] = buildpath/"gobootstrap"

    cd libexec/"src" do
      # Set portable defaults for CC/CXX to be used by cgo
      with_env(CC: "cc", CXX: "c++") { system "./make.bash" }
    end

    bin.install_symlink Dir[libexec/"bin/go*"]

    # Remove useless files.
    # Breaks patchelf because folder contains weird debug/test files
    rm_r(libexec/"src/debug/elf/testdata")
    # Binaries built for an incompatible architecture
    rm_r(libexec/"src/runtime/pprof/testdata")
    # Remove testdata with binaries for non-native architectures.
    rm_r(libexec/"src/debug/dwarf/testdata")
  end

  test do
    (testpath/"hello.go").write <<~GO
      package main

      import "fmt"

      func main() {
          fmt.Println("Hello World")
      }
    GO

    # Run go fmt check for no errors then run the program.
    # This is a a bare minimum of go working as it uses fmt, build, and run.
    system bin/"go", "fmt", "hello.go"
    assert_equal "Hello World\n", shell_output("#{bin}/go run hello.go")

    with_env(GOOS: "freebsd", GOARCH: "amd64") do
      system bin/"go", "build", "hello.go"
    end

    (testpath/"hello_cgo.go").write <<~GO
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
    GO

    # Try running a sample using cgo without CC or CXX set to ensure that the
    # toolchain's default choice of compilers work
    with_env(CC: nil, CXX: nil, CGO_ENABLED: "1") do
      assert_equal "Hello from cgo!\n", shell_output("#{bin}/go run hello_cgo.go")
    end
  end
end

class Go < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.25rc1.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.25rc1.src.tar.gz"
  sha256 "0cd6772fe133a784fbb7a09d6da3089897fef48d03a21721434bf88188a58629"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5094b9cb0e763d24167d36a7660697de5f8f1a455ffb5cb892f3e86bac24198b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5094b9cb0e763d24167d36a7660697de5f8f1a455ffb5cb892f3e86bac24198b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5094b9cb0e763d24167d36a7660697de5f8f1a455ffb5cb892f3e86bac24198b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f352e43db6b6980e881a3855df4c1c0097eedff135146302ccbbb4d79ebcdee"
    sha256 cellar: :any_skip_relocation, ventura:       "1f352e43db6b6980e881a3855df4c1c0097eedff135146302ccbbb4d79ebcdee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e08e43be8d671e4cfd282aae97f87b0482d5aebbae01a2f41e84e7deecdf578e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "617fd19381edf1f0ac09ca19b24ac5217f55c6b389dbd45408c3f582912e76fb"
  end

  # Don't update this unless this version cannot bootstrap the new version.
  resource "gobootstrap" do
    checksums = {
      "darwin-arm64" => "416c35218edb9d20990b5d8fc87be655d8b39926f15524ea35c66ee70273050d",
      "darwin-amd64" => "e7bbe07e96f0bd3df04225090fe1e7852ed33af37c43a23e16edbbb3b90a5b7c",
      "linux-arm64"  => "fd017e647ec28525e86ae8203236e0653242722a7436929b1f775744e26278e7",
      "linux-amd64"  => "4fa4f869b0f7fc6bb1eb2660e74657fbf04cdd290b5aef905585c86051b34d43",
    }

    version "1.22.12"

    on_arm do
      on_macos do
        url "https://storage.googleapis.com/golang/go#{version}.darwin-arm64.tar.gz"
        sha256 checksums["darwin-arm64"]
      end
      on_linux do
        url "https://storage.googleapis.com/golang/go#{version}.linux-arm64.tar.gz"
        sha256 checksums["linux-arm64"]
      end
    end
    on_intel do
      on_macos do
        url "https://storage.googleapis.com/golang/go#{version}.darwin-amd64.tar.gz"
        sha256 checksums["darwin-amd64"]
      end
      on_linux do
        url "https://storage.googleapis.com/golang/go#{version}.linux-amd64.tar.gz"
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
    with_env(CC: nil, CXX: nil) do
      assert_equal "Hello from cgo!\n", shell_output("#{bin}/go run hello_cgo.go")
    end
  end
end

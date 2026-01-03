class Go < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.26rc1.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.26rc1.src.tar.gz"
  sha256 "65e3340506f4ba125a5799ecc787ad49d4c9f4d257e2c2c15d3e295e5002b684"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a08dc2f6914ccf3edf0a4e0401595216fb890ffd253ee1147a7241e4f5dc8c15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a08dc2f6914ccf3edf0a4e0401595216fb890ffd253ee1147a7241e4f5dc8c15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a08dc2f6914ccf3edf0a4e0401595216fb890ffd253ee1147a7241e4f5dc8c15"
    sha256 cellar: :any_skip_relocation, sonoma:        "b40bc5deb0d8f4a0ed30763b774c294e2033be3af9ae1febc428260bc9080739"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "986db3b38f0108765760294d979cbe758411f9668b099ab852ca1f463d9aa2ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c44f1e34c0b26a987008b483cf22f188a0c60533277ffcb9485bf66045c82094"
  end

  depends_on macos: :monterey

  # Don't update this unless this version cannot bootstrap the new version.
  resource "gobootstrap" do
    checksums = {
      "darwin-arm64" => "a9c90c786e75d5d1da0547de2d1199034df6a4b163af2fa91b9168c65f229c12",
      "darwin-amd64" => "c45566cf265e2083cd0324e88648a9c28d0edede7b5fd12f8dc6932155a344c5",
      "linux-arm64"  => "beaf0f51cbe0bd71b8289b2b6fa96c0b11cd86aa58672691ef2f1de88eb621de",
      "linux-amd64"  => "bceca00afaac856bc48b4cc33db7cd9eb383c81811379faed3bdbc80edb0af65",
    }

    version "1.24.11"

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

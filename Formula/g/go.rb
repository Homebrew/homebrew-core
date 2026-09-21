class Go < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.27.1.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.27.1.src.tar.gz"
  sha256 "4e408abae126d916b6164627193f2c54f0e3ca1312d693b86db45f862ab238b1"
  license "BSD-3-Clause"
  compatibility_version 11
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1c7bb8cafcde128fa58d762763ad64dcbbf8fedb5d1fc47902d86a8c77790e8c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1c7bb8cafcde128fa58d762763ad64dcbbf8fedb5d1fc47902d86a8c77790e8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1c7bb8cafcde128fa58d762763ad64dcbbf8fedb5d1fc47902d86a8c77790e8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "1c7bb8cafcde128fa58d762763ad64dcbbf8fedb5d1fc47902d86a8c77790e8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "847974dcca635e9c8f495382b2bc121734126ebf074d55eebd19511cef665316"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "594b468aacbdef4bc40c30d20140f1cd60713a6a83374b44c579ba6b5eed40d4"
  end

  on_macos do
    depends_on macos: :monterey
  end

  # Don't update this unless this version cannot bootstrap the new version.
  resource "gobootstrap" do
    checksums = {
      "darwin-arm64" => "f282d882c3353485e2fc6c634606d85caf36e855167d59b996dbeae19fa7629a",
      "darwin-amd64" => "6cc6549b06725220b342b740497ffd24e0ebdcef75781a77931ca199f46ad781",
      "linux-arm64"  => "74d97be1cc3a474129590c67ebf748a96e72d9f3a2b6fef3ed3275de591d49b3",
      "linux-amd64"  => "1fc94b57134d51669c72173ad5d49fd62afb0f1db9bf3f798fd98ee423f8d730",
    }

    version "1.24.13"

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

  deny_network_access!

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

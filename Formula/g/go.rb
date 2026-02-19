class Go < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  license "BSD-3-Clause"
  compatibility_version 2
  head "https://go.googlesource.com/go.git", branch: "master"

  stable do
    url "https://go.dev/dl/go1.26.0.src.tar.gz"
    mirror "https://fossies.org/linux/misc/go1.26.0.src.tar.gz"
    sha256 "c9132a8a1f6bd2aa4aad1d74b8231d95274950483a4950657ee6c56e6e817790"

    # patch to fix pkg-config flag sanitization
    # Backport issue https://golang.org/issue/77474, should be included in 1.26.1+.
    patch do
      url "https://github.com/golang/go/commit/28fbdf7acb4146b5bc3d88128e407d1344691839.patch?full_index=1"
      sha256 "2e05f7e16f2320685547a7ebb240163a8b7f1c7bf9d2f6dc4872ff8b27707a35"
    end
  end

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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54b39d76b59f388de6f95bef52a6598535165ad72133ca413a5d81c9f87d3633"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54b39d76b59f388de6f95bef52a6598535165ad72133ca413a5d81c9f87d3633"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54b39d76b59f388de6f95bef52a6598535165ad72133ca413a5d81c9f87d3633"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9b8fa3213f0e04234c8d7a0dd54ba4dc198dcf6eb5fd3b96dd8257b51c8b7c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab3d100a21cc7a4477ce3911dadaddea17f2963ae8751dc6e2d4f7cc56704559"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f008aec1edbbe32d582f7610e83d54fcccd8fc5654d0bd830bf3b48d24592cf"
  end

  depends_on macos: :monterey

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

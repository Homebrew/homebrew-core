class Go < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.21.3.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.21.3.src.tar.gz"
  sha256 "186f2b6f8c8b704e696821b09ab2041a5c1ee13dcbc3156a13adcf75931ee488"
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
    sha256 arm64_sonoma:   "ff514eb6dcfd1b05b26feccc795714ed8a37e469548d0f00d11a88069512a1d6"
    sha256 arm64_ventura:  "ebe4b40edd2cea6e5a1451d0b46e59ca4f6afdceb96cee2a5d818246402af1fc"
    sha256 arm64_monterey: "95611f3f3d5964fa3e99bde2b8a12ada38dbdea6150f26531ffbd39a076300cb"
    sha256 sonoma:         "efbedc83dd8336b26d7261ed886b4170b57bbea9bc7382cc3964c0dc0d2da31c"
    sha256 ventura:        "b82926866b95c92f2e859c6431dbb5cfa72d683139adc30cffbb5df4a7418e02"
    sha256 monterey:       "f08664ec7a6d288c51f7115e0ede1d031c336720b71af0ca56b6113c1252c756"
    sha256 x86_64_linux:   "96bf63d3d6ea6bcc942668b4a0d69e2f2d403272ec12d935d3b8a57c257f9395"
  end

  # Don't update this unless this version cannot bootstrap the new version.
  resource "gobootstrap" do
    checksums = {
      "darwin-arm64" => "e4ccc9c082d91eaa0b866078b591fc97d24b91495f12deb3dd2d8eda4e55a6ea",
      "darwin-amd64" => "c101beaa232e0f448fab692dc036cd6b4677091ff89c4889cc8754b1b29c6608",
      "linux-arm64"  => "914daad3f011cc2014dea799bb7490442677e4ad6de0b2ac3ded6cee7e3f493d",
      "linux-amd64"  => "4cdd2bc664724dc7db94ad51b503512c5ae7220951cac568120f64f8e94399fc",
    }

    version "1.17.13"

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
    (buildpath/"gobootstrap").install resource("gobootstrap")
    ENV["GOROOT_BOOTSTRAP"] = buildpath/"gobootstrap"

    cd "src" do
      ENV["GOROOT_FINAL"] = libexec
      # Set portable defaults for CC/CXX to be used by cgo
      with_env(CC: "cc", CXX: "c++") { system "./make.bash" }
    end

    rm_rf "gobootstrap" # Bootstrap not required beyond compile.
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

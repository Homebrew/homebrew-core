class Go < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.23rc2.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.23rc2.src.tar.gz"
  sha256 "f699ce2560fc22ad82c06b1e04b6318b85e7f686cbcb4fce156582132c57d8fb"
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
    sha256 arm64_sonoma:   "17ef3a73bb9bb81ffe1740b39a1c67aaddfd4a3bd5331e8320ed2d271050bccb"
    sha256 arm64_ventura:  "e0c90cc0d99346b2fd15bbd2afcda14482c0e8dcca705a8d791e68ed95205e48"
    sha256 arm64_monterey: "ec24fed844297c26be4a92747679b2b4812a3be5a3994c9c093752b341a12fbd"
    sha256 sonoma:         "495e61c0368249b6900326eb034c2f68fdca3f0080deae4d6f1910ae444a7e20"
    sha256 ventura:        "18832c8bc6d0ec271f953cee2f82c9aab2e6b7c0d9372f1a2aabeb87acf4f3d6"
    sha256 monterey:       "7fee28073754ab9139810898778d0192cd203e9c70376c3a9fe65bdc6ee2374a"
    sha256 x86_64_linux:   "00dd1e58e304048f0978a73b14ce69f4070e52271a121662c8dc244ad4d1f0f1"
  end

  # Don't update this unless this version cannot bootstrap the new version.
  resource "gobootstrap" do
    checksums = {
      "darwin-arm64" => "6da3f76164b215053daf730a9b8f1d673dbbaa4c61031374a6744b75cb728641",
      "darwin-amd64" => "754363489e2244e72cb49b4ec6ddfd6a2c60b0700f8c4876e11befb1913b11c5",
      "linux-arm64"  => "2096507509a98782850d1f0669786c09727053e9fe3c92b03c0d96f48700282b",
      "linux-amd64"  => "ff445e48af27f93f66bd949ae060d97991c83e11289009d311f25426258f9c44",
    }

    version "1.20.14"

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

    rm_r("gobootstrap") # Bootstrap not required beyond compile.
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

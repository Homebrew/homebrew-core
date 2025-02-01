class Go < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.24rc2.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.24rc2.src.tar.gz"
  sha256 "ba07b6863f208160e8f09f11c8b9582729b51cfeb752ce6ba79a379b4fbcac6d"
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
    sha256 arm64_sequoia: "ffe37169c9f03d4648871fba9d58c4342e59c1665c7ef68493765702ca2a3a44"
    sha256 arm64_sonoma:  "ffe37169c9f03d4648871fba9d58c4342e59c1665c7ef68493765702ca2a3a44"
    sha256 arm64_ventura: "ffe37169c9f03d4648871fba9d58c4342e59c1665c7ef68493765702ca2a3a44"
    sha256 sonoma:        "91888e640405268fa1033ef7b30ae5505078414a34beaa32936dd331412d87cb"
    sha256 ventura:       "91888e640405268fa1033ef7b30ae5505078414a34beaa32936dd331412d87cb"
    sha256 x86_64_linux:  "e0d762728d9b395274427ef357610269206b288bd876e8fd345a0f96e4136514"
  end

  # Don't update this unless this version cannot bootstrap the new version.
  resource "gobootstrap" do
    checksums = {
      "darwin-arm64" => "3980b1d2be042a164989f2fd24f0bb306a2397d581a29c7426885578b369db5d",
      "darwin-amd64" => "c6d130066d509ccca1164d84514905b1e8dc5f5f4c25c24113f1b65ad87cd020",
      "linux-arm64"  => "9ebfcab26801fa4cf0627c6439db7a4da4d3c6766142a3dd83508240e4f21031",
      "linux-amd64"  => "0fc88d966d33896384fbde56e9a8d80a305dc17a9f48f1832e061724b1719991",
    }

    version "1.22.11"

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

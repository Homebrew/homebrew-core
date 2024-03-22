class Go < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.22.1.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.22.1.src.tar.gz"
  sha256 "79c9b91d7f109515a25fc3ecdaad125d67e6bdb54f6d4d98580f46799caea321"
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
    sha256 arm64_sonoma:   "357ac66ade847efda1d5bf04249a2f913c7eb50f2dc9b3c4849825d62b5758f7"
    sha256 arm64_ventura:  "83454361a3c913a424058659babc5867a0210850d7c8cbc925bd7b426e6e6ead"
    sha256 arm64_monterey: "3be1788218ac2c51b27321ed215ed8c462f6089f4e3c3a3fb98841083ab74dd4"
    sha256 sonoma:         "d677915bd8463a26331473b72f287c8d78651efcd08b497fe50753177bfbb6d9"
    sha256 ventura:        "69e0d8c40f097d313a702b48d8a59a1d1bbef16c358fea0031fbaead9166b5d7"
    sha256 monterey:       "3ded8ed8d83478d452807c9afa82bf85f6e958929cdb8a64fc01c79e02e7f218"
    sha256 x86_64_linux:   "80f41e86463fb661b1f22b79338d41e0d0b68248245829ee63b1976d75cd161c"
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

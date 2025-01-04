class Go < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.24rc1.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.24rc1.src.tar.gz"
  sha256 "afd8a23fd260f2a246d174049a076b8a05bb0bad93f1220768d219b8bdf7539d"
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
    rebuild 1
    sha256 arm64_sequoia: "ce9aad234b15d873fcd727306ab7a361db924b449f527904b3614c3aa4773767"
    sha256 arm64_sonoma:  "ce9aad234b15d873fcd727306ab7a361db924b449f527904b3614c3aa4773767"
    sha256 arm64_ventura: "ce9aad234b15d873fcd727306ab7a361db924b449f527904b3614c3aa4773767"
    sha256 sonoma:        "333dc0e36f21c81f8b07f8b0d9125a6cc0b16979de9d996979bf1eff6280b9bf"
    sha256 ventura:       "333dc0e36f21c81f8b07f8b0d9125a6cc0b16979de9d996979bf1eff6280b9bf"
    sha256 x86_64_linux:  "b18da6cb774e738cb65bd9840521a85c1eda42323e3264730794624a81dcfa64"
  end

  # Don't update this unless this version cannot bootstrap the new version.
  resource "gobootstrap" do
    checksums = {
      "darwin-arm64" => "21cf49415ffe0755b45f2b63e75d136528a32f7bb7bdd0166f51d22a03eb0a3f",
      "darwin-amd64" => "dd2c4ac3702658c2c20e3a8b394da1917d86156b2cb4312c9d2f657f80067874",
      "linux-arm64"  => "5213c5e32fde3bd7da65516467b7ffbfe40d2bb5a5f58105e387eef450583eec",
      "linux-amd64"  => "736ce492a19d756a92719a6121226087ccd91b652ed5caec40ad6dbfb2252092",
    }

    version "1.22.10"

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
    inreplace "go.env" do |s|
      # Remove misleading comment about automatically downloading newer toolchains.
      s.gsub!(/^# Automatically download.*$/, "")
      s.gsub!(/^GOTOOLCHAIN=.*$/, "GOTOOLCHAIN=local")
    end

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

  def caveats
    <<~EOS
      Homebrew's Go toolchain is configured with
        GOTOOLCHAIN=local
      per Homebrew policy on tools that update themselves.
    EOS
  end

  test do
    assert_equal "local", shell_output("#{bin}/go env GOTOOLCHAIN").strip

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

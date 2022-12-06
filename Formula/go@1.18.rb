class GoAT118 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.18.9.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.18.9.src.tar.gz"
  sha256 "fbe7f09b96aca3db6faeaf180da8bb632868ec049731e355ff61695197c0e3ea"
  license "BSD-3-Clause"

  livecheck do
    url "https://go.dev/dl/"
    regex(/href=.*?go[._-]?v?(1\.18(?:\.\d+)*)[._-]src\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "ae71f0865a9cebfd34201a83477545abaf128522d076f252e0b587322112a3a2"
    sha256 arm64_monterey: "d65e237ccc5a3e49d5e2fb8384950500c1073bc4f72647daa90a4a354bb36c48"
    sha256 arm64_big_sur:  "6cbd1bc3aca598fc30a97423493eae8737db95d31605fc81bac85bbcfb520b23"
    sha256 ventura:        "f2e14af7d3bb8635dfdb4f3f656e85499c47d475d41e4d3290d981c15f2bd5f8"
    sha256 monterey:       "555bb5c31e7ecc2f0818e44ccb5e811b37057c3f93485438b7b272d85163eee5"
    sha256 big_sur:        "d74b1dace5e3248234526bea467b9fe3d8be00fb2234318b1f54195563f11884"
    sha256 catalina:       "cdd22c4193d33f2bc695719d569c1f022dbbdc03c0804456b46a31569548b7b8"
    sha256 x86_64_linux:   "a5b8e2135e087f1770932b58da9ef94d97edf20be30c692dc1042b93308eab41"
  end

  keg_only :versioned_formula

  # Don't update this unless this version cannot bootstrap the new version.
  resource "gobootstrap" do
    checksums = {
      "darwin-arm64" => "4dac57c00168d30bbd02d95131d5de9ca88e04f2c5a29a404576f30ae9b54810",
      "darwin-amd64" => "6000a9522975d116bf76044967d7e69e04e982e9625330d9a539a8b45395f9a8",
      "linux-arm64"  => "3770f7eb22d05e25fbee8fb53c2a4e897da043eb83c69b9a14f8d98562cd8098",
      "linux-amd64"  => "013a489ebb3e24ef3d915abe5b94c3286c070dfe0818d5bca8108f1d6e8440d2",
    }

    arch = "arm64"
    platform = "darwin"

    on_intel do
      arch = "amd64"
    end

    on_linux do
      platform = "linux"
    end

    boot_version = "1.16"

    url "https://storage.googleapis.com/golang/go#{boot_version}.#{platform}-#{arch}.tar.gz"
    version boot_version
    sha256 checksums["#{platform}-#{arch}"]
  end

  def install
    (buildpath/"gobootstrap").install resource("gobootstrap")
    ENV["GOROOT_BOOTSTRAP"] = buildpath/"gobootstrap"

    cd "src" do
      ENV["GOROOT_FINAL"] = libexec
      system "./make.bash", "--no-clean"
    end

    (buildpath/"pkg/obj").rmtree
    rm_rf "gobootstrap" # Bootstrap not required beyond compile.
    libexec.install Dir["*"]
    bin.install_symlink Dir[libexec/"bin/go*"]

    system bin/"go", "install", "-race", "std"

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

    ENV["GOOS"] = "freebsd"
    ENV["GOARCH"] = "amd64"
    system bin/"go", "build", "hello.go"
  end
end

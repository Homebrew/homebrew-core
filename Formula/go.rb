class Go < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.18.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.18.src.tar.gz"
  sha256 "38f423db4cc834883f2b52344282fa7a39fbb93650dc62a11fdf0be6409bdad6"
  license "BSD-3-Clause"
  head "https://go.googlesource.com/go.git", branch: "master"

  livecheck do
    url "https://go.dev/dl/"
    regex(/href=.*?go[._-]?v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "4c41604ae9c2432749c8c1ccad827541115b19708bd431123249a0617ad9839a"
    sha256 arm64_big_sur:  "b39ba0aa22d888cb0813564fd87ef0d6b0d95108060f85a5d91b418c9c506b41"
    sha256 monterey:       "dbbe797302016b06172235c95aef295d48ed09dd962c1e5b611ea6523c13d7f5"
    sha256 big_sur:        "5dfda57937f94683cbe1b31e10b7ed4d0661722ece896dca9cb0c17bbbeaa52a"
    sha256 catalina:       "4a9309d9a9158f0b5a34f18eb7245a2ae45a5dd459d0826918eed6f6929c8846"
    sha256 x86_64_linux:   "47e6f642cf4a5dfe65c2171c7096bf3c4c56ba5b1b55b4ca902156b1b9e254c1"
  end

  # Don't update this unless this version cannot bootstrap the new version.
  resource "gobootstrap" do
    on_macos do
      if Hardware::CPU.arm?
        url "https://storage.googleapis.com/golang/go1.16.darwin-arm64.tar.gz"
        version "1.16"
        sha256 "4dac57c00168d30bbd02d95131d5de9ca88e04f2c5a29a404576f30ae9b54810"
      else
        url "https://storage.googleapis.com/golang/go1.16.darwin-amd64.tar.gz"
        version "1.16"
        sha256 "6000a9522975d116bf76044967d7e69e04e982e9625330d9a539a8b45395f9a8"
      end
    end

    on_linux do
      if Hardware::CPU.arm?
        url "https://storage.googleapis.com/golang/go1.16.linux-arm64.tar.gz"
        version "1.16"
        sha256 "3770f7eb22d05e25fbee8fb53c2a4e897da043eb83c69b9a14f8d98562cd8098"
      else
        url "https://storage.googleapis.com/golang/go1.16.linux-amd64.tar.gz"
        version "1.16"
        sha256 "013a489ebb3e24ef3d915abe5b94c3286c070dfe0818d5bca8108f1d6e8440d2"
      end
    end
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

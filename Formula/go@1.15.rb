class GoAT115 < Formula
  desc "Go programming environment (1.15)"
  homepage "https://golang.org"
  url "https://golang.org/dl/go1.15.15.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.15.15.src.tar.gz"
  sha256 "0662ae3813330280d5f1a97a2ee23bbdbe3a5a7cfa6001b24a9873a19a0dc7ec"
  license "BSD-3-Clause"

  livecheck do
    url "https://golang.org/dl/"
    regex(/href=.*?go[._-]?v?(1\.15(?:\.\d+)*)[._-]src\.t/i)
  end

  bottle do
    sha256 big_sur:      "4b7fd6ddbe755f924fd0c5509ed9c638445b2cfc973f96ecf1537430710ead3e"
    sha256 catalina:     "b916522c4dc3929e9370f3306476b100b0a42cac514b713eb507a47c7a843d4a"
    sha256 mojave:       "f7d745f62de99ef286c5d0f554964a2242bd0be29ee954be09a0ef9419d6ac2a"
    sha256 x86_64_linux: "c1ff74df94ea43dfb4e4d8a29889938a4179bcfd4315a3805536b0b10bd4399c"
  end

  keg_only :versioned_formula

  depends_on arch: :x86_64

  # Don't update this unless this version cannot bootstrap the new version.
  resource "gobootstrap" do
    on_macos do
      url "https://storage.googleapis.com/golang/go1.7.darwin-amd64.tar.gz"
      sha256 "51d905e0b43b3d0ed41aaf23e19001ab4bc3f96c3ca134b48f7892485fc52961"
    end

    on_linux do
      url "https://storage.googleapis.com/golang/go1.7.linux-amd64.tar.gz"
      sha256 "702ad90f705365227e902b42d91dd1a40e48ca7f67a2f4b2fd052aaa4295cd95"
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

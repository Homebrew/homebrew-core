class GoAT115 < Formula
  desc "Go programming environment (1.15)"
  homepage "https://golang.org"
  url "https://golang.org/dl/go1.15.15.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.15.15.src.tar.gz"
  sha256 "0662ae3813330280d5f1a97a2ee23bbdbe3a5a7cfa6001b24a9873a19a0dc7ec"
  license "BSD-3-Clause"

  bottle do
    sha256 big_sur:      "964306dbdbee74e9a1cf731e20132e49ad7827dd6baeaf75382337c854e15cd2"
    sha256 catalina:     "9ef40146c7742f26d93e612f7bef94dc4bfcde58d962f1fd2ec1fe441c12a09b"
    sha256 mojave:       "289c85810eb97728426641d075afbbce1eeb827d782acf748485d23c2bce1469"
    sha256 x86_64_linux: "bee975f9e9e50c4c580b06d4f578e0971c0bc4cc6ebb1e335018100b364eed7a"
  end

  keg_only :versioned_formula

  disable! date: "2022-10-19", because: :unsupported

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

class Go < Formula
  desc "The Go programming language"
  homepage "https://golang.org"
  revision 1

  stable do
    url "https://storage.googleapis.com/golang/go1.8.src.tar.gz"
    mirror "https://fossies.org/linux/misc/go1.8.src.tar.gz"
    version "1.8"
    sha256 "406865f587b44be7092f206d73fc1de252600b79b3cacc587b74b5ef5c623596"

    go_version = version.to_s.split(".")[0..1].join(".")
    resource "gotools" do
      url "https://go.googlesource.com/tools.git",
          :branch => "release-branch.go#{go_version}"
    end

    # Fixes for https://github.com/golang/go/issues/19734.
    patch do
      url "https://github.com/golang/go/commit/84192f27.patch"
      sha256 "86badcb9318b5399de05520cfdd3c1abbc722a5f8cfcecc008815ff889230620"
    end

    patch do
      url "https://github.com/golang/go/commit/3ca0d34f.patch"
      sha256 "7c3a0ce6cf9bec784729bdca8f1798629690042c69cb4ee8c5e9cafaf73fc693"
    end

    patch do
      url "https://github.com/golang/go/commit/2d004301.patch"
      sha256 "2444a4191fd299b8a6e6eb6a671e7ca53005d0785b85343e5b512d4f093a069a"
    end
  end

  bottle do
    sha256 "12b06bc52ed7c098795aed349726d302ccd719f81e12f3480cef0993823612d2" => :sierra
    sha256 "b2ad7e4dec21a35432f3ddfcbfff7d05e872f1a657cba7ef6685f5a706a6cc16" => :el_capitan
    sha256 "13cabcae9acdbebb3f430bac8fe0ad2eb4849f480967d12c12d9e6de93b3736c" => :yosemite
  end

  head do
    url "https://go.googlesource.com/go.git"

    resource "gotools" do
      url "https://go.googlesource.com/tools.git"
    end
  end

  option "without-cgo", "Build without cgo (also disables race detector)"
  option "without-godoc", "godoc will not be installed for you"
  option "without-race", "Build without race detector"

  depends_on :macos => :mountain_lion

  # Don't update this unless this version cannot bootstrap the new version.
  resource "gobootstrap" do
    url "https://storage.googleapis.com/golang/go1.7.darwin-amd64.tar.gz"
    version "1.7"
    sha256 "51d905e0b43b3d0ed41aaf23e19001ab4bc3f96c3ca134b48f7892485fc52961"
  end

  def install
    (buildpath/"gobootstrap").install resource("gobootstrap")
    ENV["GOROOT_BOOTSTRAP"] = buildpath/"gobootstrap"

    cd "src" do
      ENV["GOROOT_FINAL"] = libexec
      ENV["GOOS"]         = "darwin"
      ENV["CGO_ENABLED"]  = "0" if build.without?("cgo")
      system "./make.bash", "--no-clean"
    end

    (buildpath/"pkg/obj").rmtree
    rm_rf "gobootstrap" # Bootstrap not required beyond compile.
    libexec.install Dir["*"]
    bin.install_symlink Dir[libexec/"bin/go*"]

    # Race detector only supported on amd64 platforms.
    # https://golang.org/doc/articles/race_detector.html
    if build.with?("cgo") && build.with?("race") && MacOS.prefer_64_bit?
      system bin/"go", "install", "-race", "std"
    end

    if build.with? "godoc"
      ENV.prepend_path "PATH", bin
      ENV["GOPATH"] = buildpath
      (buildpath/"src/golang.org/x/tools").install resource("gotools")

      if build.with? "godoc"
        cd "src/golang.org/x/tools/cmd/godoc/" do
          system "go", "build"
          (libexec/"bin").install "godoc"
        end
        bin.install_symlink libexec/"bin/godoc"
      end
    end
  end

  def caveats; <<-EOS.undent
    A valid GOPATH is required to use the `go get` command.
    If $GOPATH is not specified, $HOME/go will be used by default:
      https://golang.org/doc/code.html#GOPATH

    You may wish to add the GOROOT-based install location to your PATH:
      export PATH=$PATH:#{opt_libexec}/bin
    EOS
  end

  test do
    (testpath/"hello.go").write <<-EOS.undent
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

    if build.with? "godoc"
      assert File.exist?(libexec/"bin/godoc")
      assert File.executable?(libexec/"bin/godoc")
    end

    if build.with? "cgo"
      ENV["GOOS"] = "freebsd"
      system bin/"go", "build", "hello.go"
    end
  end
end

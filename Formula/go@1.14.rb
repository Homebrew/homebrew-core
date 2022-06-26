class GoAT114 < Formula
  desc "Go programming environment (1.14)"
  homepage "https://golang.org"
  url "https://golang.org/dl/go1.14.15.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.14.15.src.tar.gz"
  sha256 "7ed13b2209e54a451835997f78035530b331c5b6943cdcd68a3d815fdc009149"
  license "BSD-3-Clause"

  bottle do
    sha256 big_sur:      "faf9dc9e47037a6676239fe00904c43822c622f40f0a7e6d524b1a6b770292b8"
    sha256 catalina:     "896c37117ef621d065878a9a97f20ebc5ad5485188cff533db398edf744fb59a"
    sha256 mojave:       "e019d7cb4097d0e7bcfa3ad7df15eb5030a01255fdf52fbbb956bbdc3f424f8c"
    sha256 x86_64_linux: "5aff0b2ef09ce98fbf0b9a2d80679dbbe88a39b214236bcd67667f017b53fc58"
  end

  keg_only :versioned_formula

  deprecate! date: "2021-02-16", because: :unsupported

  depends_on arch: :x86_64

  resource "gotools" do
    url "https://go.googlesource.com/tools.git",
        branch: "release-branch.go1.14"
  end

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

    # Build and install godoc
    ENV.prepend_path "PATH", bin
    ENV["GOPATH"] = buildpath
    (buildpath/"src/golang.org/x/tools").install resource("gotools")
    cd "src/golang.org/x/tools/cmd/godoc/" do
      system "go", "build"
      (libexec/"bin").install "godoc"
    end
    bin.install_symlink libexec/"bin/godoc"
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

    # godoc was installed
    assert_predicate libexec/"bin/godoc", :exist?
    assert_predicate libexec/"bin/godoc", :executable?

    ENV["GOOS"] = "freebsd"
    ENV["GOARCH"] = "amd64"
    system bin/"go", "build", "hello.go"
  end
end

class GoAT114 < Formula
  desc "Go programming environment (1.14)"
  homepage "https://golang.org"
  url "https://golang.org/dl/go1.14.13.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.14.13.src.tar.gz"
  sha256 "ba1d244c6b5c0ed04aa0d7856d06aceb89ed31b895de6ff783efb1cc8ab6b177"
  license "BSD-3-Clause"

  livecheck do
    url "https://golang.org/dl/"
    regex(/href=.*?go[._-]?v?(1\.14(?:\.\d+)*)[._-]src\.t/i)
  end

  bottle do
    sha256 "40e5d0db81c6ac340fc21dd33698cf7474aada9711e046f8d90da3201a50babd" => :big_sur
    sha256 "d38b78e34a60be87ba8d3cf3fb7e8fe0ed73de7ccb66ad912913633349b6ced9" => :catalina
    sha256 "a4ada63752ff72dcce99582ad24423ccb08107431304f00493e7355643c8f3d5" => :mojave
    sha256 "49e3e33f162f8161b04413981df3ec613490872d055b55de6b0274afc2d0ae43" => :high_sierra
  end

  keg_only :versioned_formula

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

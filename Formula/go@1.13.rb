class GoAT113 < Formula
  desc "Go programming environment (1.13)"
  homepage "https://golang.org"
  url "https://golang.org/dl/go1.13.15.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.13.15.src.tar.gz"
  sha256 "5fb43171046cf8784325e67913d55f88a683435071eef8e9da1aa8a1588fcf5d"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 "4c728bf1466cdd0d9fa6f9ed3a565e4a2203717730603189d8b5f2675a008c88" => :catalina
    sha256 "d994ff2b27c191bb74dd44a373e254ef92472c1cb13e381cf6bf9d3d118bdaef" => :mojave
    sha256 "4c62c487e96657aabebc01f662c2506724e123a08bdf3ead0715945c9838429c" => :high_sierra
  end

  keg_only :versioned_formula

  deprecate! date: "2020-08-11", because: :unsupported

  resource "gotools" do
    url "https://go.googlesource.com/tools.git",
        branch: "release-branch.go1.13"
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

class GoAT112 < Formula
  desc "Go programming environment (1.12)"
  homepage "https://golang.org"
  url "https://dl.google.com/go/go1.12.17.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.12.17.src.tar.gz"
  sha256 "de878218c43aa3c3bad54c1c52d95e3b0e5d336e1285c647383e775541a28b25"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 "981dab2b0af4a0ed5a36bb9ed31f109852cfefed5db8a10aa4624113536d0bbf" => :big_sur
    sha256 "44d6c83a39c231cae86af05b3689cb2ec03be389562c1cc5e84a9f68ed09af80" => :catalina
    sha256 "dc3b90a9ba13c31928c92227957d530656bab53d5ca3a35bfab02038118a964e" => :mojave
    sha256 "e42c02a42a4d2df97cba11e80729e8439e7476745548bd7ee23d72858c22a3f1" => :high_sierra
  end

  keg_only :versioned_formula

  deprecate! date: "2020-02-25", because: :unsupported

  depends_on arch: :x86_64

  resource "gotools" do
    url "https://go.googlesource.com/tools.git",
        branch: "release-branch.go1.12"
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
    ENV["GO111MODULE"] = "on"
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
    system bin/"go", "build", "hello.go"
  end
end

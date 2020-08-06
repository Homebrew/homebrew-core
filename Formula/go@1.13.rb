class GoAT113 < Formula
  desc "Go programming environment (1.13)"
  homepage "https://golang.org"
  url "https://golang.org/dl/go1.13.15.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.13.15.src.tar.gz"
  sha256 "5fb43171046cf8784325e67913d55f88a683435071eef8e9da1aa8a1588fcf5d"
  license "BSD-3-Clause"

  bottle do
    sha256 "1b95cff8f94bcf3926511d4bac481e6593eaff5a47b2547e70cad7f6c733b794" => :catalina
    sha256 "c36ef71328bab2c9229d91bbc9b7477ad56fa010aad022a197675cdda4c65486" => :mojave
    sha256 "00f0a722e2dee59002d6adc91571505e047361dff60e2f466ab1e230edd0b042" => :high_sierra
  end

  keg_only :versioned_formula

  depends_on macos: :el_capitan

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
      ENV["GOOS"]         = "darwin"
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

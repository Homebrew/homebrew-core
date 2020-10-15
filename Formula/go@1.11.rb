class GoAT111 < Formula
  desc "Go programming environment (1.11)"
  homepage "https://golang.org"
  url "https://dl.google.com/go/go1.11.13.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.11.13.src.tar.gz"
  sha256 "5032095fd3f641cafcce164f551e5ae873785ce7b07ca7c143aecd18f7ba4076"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 "077ca87532424c95f5072fa0d6cb0aa316fb6c6309ba9ad8d158556ddf264792" => :catalina
    sha256 "8f9794052cd1e44eedd34c5a28fd7614cb21e1c67d54a8c4b5733115f04978c8" => :mojave
    sha256 "c42368b27f9f70e02a858a3bbf07f73e41295512191d8b7b524a474b8157e91a" => :high_sierra
  end

  keg_only :versioned_formula

  deprecate! date: "2019-09-03", because: :unsupported

  resource "gotools" do
    url "https://go.googlesource.com/tools.git",
        branch: "release-branch.go1.11"
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

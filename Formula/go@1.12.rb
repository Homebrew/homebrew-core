class GoAT112 < Formula
  desc "Go programming environment (1.12)"
  homepage "https://golang.org"
  url "https://dl.google.com/go/go1.12.12.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.12.12.src.tar.gz"
  sha256 "fcb33b5290fa9bcc52be3211501540df7483d7276b031fc77528672a3c705b99"

  bottle do
    sha256 "d03e13dd7154381bad4197a410379c370cd07cb546a1861c2ece986a72ce343b" => :catalina
    sha256 "e7b2c51fd3e0dbebb137929ef5a78c7710cd992fbee5e061a6fee5c13e524b89" => :mojave
    sha256 "666adadacd208ed6b9fef5db46835f4dadfb39f646d48bf36d2d8e30b9e1f201" => :high_sierra
  end

  keg_only :versioned_formula

  depends_on :macos => :yosemite

  resource "gotools" do
    url "https://go.googlesource.com/tools.git",
        :branch => "release-branch.go1.12"
  end

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

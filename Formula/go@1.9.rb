class GoAT19 < Formula
  desc "Go programming environment (1.9)"
  homepage "https://golang.org"
  url "https://dl.google.com/go/go1.9.7.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.9.7.src.tar.gz"
  sha256 "582814fa45e8ecb0859a208e517b48aa0ad951e3b36c7fff203d834e0ef27722"

  bottle do
    rebuild 1
    sha256 "6820e19509cbcdd77f30cb8c16a4ca9e67aa3e9eb6e4c2da33c9f9a7dc223840" => :catalina
    sha256 "74df95ba98388a1617c604e3a439b61c785ac74dc653d2d06da8be2b88e77084" => :mojave
    sha256 "02584ef8cae5f91f3c4fda26a946c09de1635854782e1c1f1201f35b680df61b" => :high_sierra
    sha256 "2f837e2b6745a970e4d3bd9b3f5ea0ed1ebb827ade2cfa38793f0b9a5232ed9e" => :sierra
  end

  keg_only :versioned_formula

  resource "gotools" do
    url "https://go.googlesource.com/tools.git",
        :branch => "release-branch.go1.9"
  end

  # Don't update this unless this version cannot bootstrap the new version.
  resource "gobootstrap" do
    url "https://storage.googleapis.com/golang/go1.7.darwin-amd64.tar.gz"
    version "1.7"
    sha256 "51d905e0b43b3d0ed41aaf23e19001ab4bc3f96c3ca134b48f7892485fc52961"
  end

  # Backports the following commit from 1.10/1.11:
  # https://github.com/golang/go/commit/1a92cdbfc10e0c66f2e015264a39159c055a5c15
  patch do
    url "https://github.com/Homebrew/formula-patches/raw/e089e057dbb8aff7d0dc36a6c1933c29dca9c77e/go%401.9/go_19_load_commands.patch"
    sha256 "771b67df44e3d5d5d7c01ea4a0d1693032bc880ea4f16cf82c1bacb42bfd9b10"
  end

  # Prevents Go from building malformed binaries. Fixed upstream, should
  # be in a future release.
  # https://github.com/golang/go/issues/32673
  patch do
    url "https://github.com/golang/go/commit/26954bde4443c4bfbfe7608f35584b6b810f3f2c.patch?full_index=1"
    sha256 "25a361bd4aa1155be06e2239c1974aa9c59f971210f19e16a3b7b576b9d4f677"
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
    system bin/"go", "build", "hello.go"
  end
end

class GoAT110 < Formula
  desc "Go programming environment (1.10)"
  homepage "https://golang.org"
  url "https://dl.google.com/go/go1.10.8.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.10.8.src.tar.gz"
  sha256 "6faf74046b5e24c2c0b46e78571cca4d65e1b89819da1089e53ea57539c63491"

  bottle do
    rebuild 1
    sha256 "463f46d45774a9c16406a8440e32ad0c66fc6d02e8efdd8bd089d43a2e1b0b19" => :catalina
    sha256 "74de45b702bd3fecae70ad1492ab48b90dbcd0526b5f212d067a9fb30d3142da" => :mojave
    sha256 "669a59bb6f7490fccdd4b116418e05f16c649ec4fc185b0cfa9e023346915fcd" => :high_sierra
    sha256 "b3cf0891e8bfd66a7b1904e44776957550637e8914326e6282d0290aea5a1d7f" => :sierra
  end

  keg_only :versioned_formula

  resource "gotools" do
    url "https://go.googlesource.com/tools.git",
        :branch => "release-branch.go1.10"
  end

  # Don't update this unless this version cannot bootstrap the new version.
  resource "gobootstrap" do
    url "https://storage.googleapis.com/golang/go1.7.darwin-amd64.tar.gz"
    version "1.7"
    sha256 "51d905e0b43b3d0ed41aaf23e19001ab4bc3f96c3ca134b48f7892485fc52961"
  end

  # Prevents Go from building malformed binaries. Fixed upstream, should
  # be in a future release.
  # https://github.com/golang/go/issues/32673
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/b8d26872202f4efc9797a51265b868f7ebc0d03a/go%401.10/dwarf_segments.patch"
    sha256 "7bdf34196f5e8f7de705670e6199cf7dc22835f9a188af3e319aed60f7398ff6"
  end

  def install
    (buildpath/"gobootstrap").install resource("gobootstrap")
    ENV["GOROOT_BOOTSTRAP"] = buildpath/"gobootstrap"

    cd "go/src" do
      ENV["GOROOT_FINAL"] = libexec
      ENV["GOOS"]         = "darwin"
      system "./make.bash", "--no-clean"
    end

    (buildpath/"go/pkg/obj").rmtree
    rm_rf "gobootstrap" # Bootstrap not required beyond compile.
    libexec.install Dir["*"]
    bin.install_symlink Dir[libexec/"go/bin/go*"]

    system bin/"go", "install", "-race", "std"

    # Build and install godoc
    ENV.prepend_path "PATH", bin
    ENV["GOPATH"] = buildpath/"go"
    (buildpath/"go/src/golang.org/x/tools").install resource("gotools")
    cd "go/src/golang.org/x/tools/cmd/godoc/" do
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

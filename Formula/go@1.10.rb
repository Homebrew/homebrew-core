class GoAT110 < Formula
  desc "Go programming environment (1.10)"
  homepage "https://golang.org"
  url "https://dl.google.com/go/go1.10.8.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.10.8.src.tar.gz"
  sha256 "6faf74046b5e24c2c0b46e78571cca4d65e1b89819da1089e53ea57539c63491"
  license "BSD-3-Clause"

  bottle do
    rebuild 2
    sha256 big_sur:     "b61ba9c56d4064290af620c92e23ce5f5428c8a4a9964c787d62e0f20a142d57"
    sha256 catalina:    "fa6f1fcd01302191009869886cf56208a42224ad86e201ebd98be6346f72f4a3"
    sha256 mojave:      "b00703a47e9352ee299c81d269c66209edca69605d06b2ce031b9754b8da56e6"
    sha256 high_sierra: "395dcfc97f048bf95efedcf084206d730dba4ba59391075869b6cbae8d4ad0c1"
  end

  keg_only :versioned_formula

  disable! date: "2021-02-16", because: :unsupported

  depends_on arch: :x86_64

  resource "gotools" do
    url "https://go.googlesource.com/tools.git",
        branch: "release-branch.go1.10"
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

  # Prevents Go from building malformed binaries. Fixed upstream, should
  # be in a future release.
  # https://github.com/golang/go/issues/32673
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/b8d26872202f4efc9797a51265b868f7ebc0d03a/go%401.10/dwarf_segments.patch"
    sha256 "7bdf34196f5e8f7de705670e6199cf7dc22835f9a188af3e319aed60f7398ff6"
  end

  def install
    if OS.linux?
      # Fixes: Error: Failure while executing: ../bin/ldd ../line-clang.elf: Permission denied
      chmod "+x", Dir.glob("src/debug/dwarf/testdata/*.elf")
      chmod "+x", Dir.glob("src/debug/elf/testdata/*-exec")
    end

    (buildpath/"gobootstrap").install resource("gobootstrap")
    ENV["GOROOT_BOOTSTRAP"] = buildpath/"gobootstrap"

    cd "go/src" do
      ENV["GOROOT_FINAL"] = libexec
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

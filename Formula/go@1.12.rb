class GoAT112 < Formula
  desc "Go programming environment (1.12)"
  homepage "https://golang.org"
  url "https://dl.google.com/go/go1.12.9.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.12.9.src.tar.gz"
  sha256 "ab0e56ed9c4732a653ed22e232652709afbf573e710f56a07f7fdeca578d62fc"

  bottle do
    sha256 "59f2dd4de08fe6eeb06462f4446ffff877b6f5395c2860296fff2838f71bba50" => :mojave
    sha256 "6652d4f496ea4491114c4d1b5ab72665d5104b3184727e1cd567d9ecec6b9434" => :high_sierra
    sha256 "046eba8cd9c18147caf9ad2e956872bef33ba6140e161b76f0ab1bb8acbe6ddd" => :sierra
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

class GoAT115 < Formula
  desc "Go programming environment (1.15)"
  homepage "https://golang.org"
  url "https://golang.org/dl/go1.15.10.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.15.10.src.tar.gz"
  sha256 "c1dbca6e0910b41d61a95bf9878f6d6e93d15d884c226b91d9d4b1113c10dd65"
  license "BSD-3-Clause"

  livecheck do
    url "https://golang.org/dl/"
    regex(/href=.*?go[._-]?v?(1\.15(?:\.\d+)*)[._-]src\.t/i)
  end

  bottle do
    sha256 big_sur:  "cc2e0707e03dbded6cee3a5cd185cbbedb96be7b80f3bbfdedbfc5ac8ad5426a"
    sha256 catalina: "4a916623a30c8111b7967e8d5f8ff1bbabf4e067b7859e98a8bdba7f0362b4fc"
    sha256 mojave:   "b00dadf96fed60c2a7cb7f426d0bad941ac676464ba447f82cd44f804b2d294c"
  end

  keg_only :versioned_formula

  depends_on arch: :x86_64

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

    ENV["GOOS"] = "freebsd"
    ENV["GOARCH"] = "amd64"
    system bin/"go", "build", "hello.go"
  end
end

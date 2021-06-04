class GoAT115 < Formula
  desc "Go programming environment (1.15)"
  homepage "https://golang.org"
  url "https://golang.org/dl/go1.15.13.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.15.13.src.tar.gz"
  sha256 "99069e7223479cce4553f84f874b9345f6f4045f27cf5089489b546da619a244"
  license "BSD-3-Clause"

  livecheck do
    url "https://golang.org/dl/"
    regex(/href=.*?go[._-]?v?(1\.15(?:\.\d+)*)[._-]src\.t/i)
  end

  bottle do
    sha256 big_sur:  "caf2c111b55f3700ebdc6e4d95b69d7e6c8e69e2a64fd6426f379bb4747ca720"
    sha256 catalina: "aa31ffb0298a88a45e1aaf69daa3d8d49373b7353b9ca5e2d38e6c800fb346eb"
    sha256 mojave:   "29bc93a49c4453e3cff32b2d26dbb9be1c3be6a5e7589b85a8da2c16e58dac4e"
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

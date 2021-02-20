class Go < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://golang.org"
  license "BSD-3-Clause"

  stable do
    if Hardware::CPU.arm?
      url "https://golang.org/dl/go1.16rc1.src.tar.gz"
      sha256 "6a33569f9d0d21db31614086cc2a4f0fbc683b41c1c53fb512a1341ce5763ff5"
      version "1.15.8"
    else
      url "https://golang.org/dl/go1.15.8.src.tar.gz"
      mirror "https://fossies.org/linux/misc/go1.15.8.src.tar.gz"
      sha256 "540c0ab7781084d124991321ed1458e479982de94454a98afab6acadf38497c2"
    end

    go_version = version.major_minor
    resource "gotools" do
      url "https://go.googlesource.com/tools.git",
          branch: "release-branch.go#{go_version}"
    end
  end

  livecheck do
    url "https://golang.org/dl/"
    regex(/href=.*?go[._-]?v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "5075e91f2c7fe5496d9fe50267b090d7372dd6b305eedd3424193c265fc268b8"
    sha256 big_sur:       "96827fc4e223eaaffe52876ee6828c54f6f264cfeb42ca2335064fb1b708e62f"
    sha256 catalina:      "61a70ed89335dc8819b278670bf2919a69fa3909a316a3acc6aa2d2ac07a1374"
    sha256 mojave:        "3500c34a8659c2c1f0fe4f0e41dc0a64d77841f31bde38e0c94139698a1e02b1"
  end

  head do
    url "https://go.googlesource.com/go.git"

    resource "gotools" do
      url "https://go.googlesource.com/tools.git"
    end
  end

  # Don't update this unless this version cannot bootstrap the new version.
  resource "gobootstrap" do
    on_macos do
      if Hardware::CPU.arm?
        url "https://storage.googleapis.com/golang/go1.16beta1.darwin-arm64.tar.gz"
        sha256 "fd57f47987bb330fd9b438e7b4c8941b63c3807366602d99c1d99e0122ec62f1"
      else
        url "https://storage.googleapis.com/golang/go1.7.darwin-amd64.tar.gz"
        sha256 "51d905e0b43b3d0ed41aaf23e19001ab4bc3f96c3ca134b48f7892485fc52961"
      end
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
    ENV["GOPATH"] = buildpath
    (buildpath/"src/golang.org/x/tools").install resource("gotools")
    cd "src/golang.org/x/tools/cmd/godoc/" do
      system "go", "build"
      (libexec/"bin").install "godoc"
    end
    bin.install_symlink libexec/"bin/godoc"
  end

  def caveats
    s = ""

    if Hardware::CPU.arm?
      s += <<~EOS
        This is a release candidate version of the Go compiler for Apple Silicon
        (Go 1.16rc1).
      EOS
    end

    s
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

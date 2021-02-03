class Go < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://golang.org"
  license "BSD-3-Clause"
  revision 1

  stable do
    if Hardware::CPU.arm?
      url "https://golang.org/dl/go1.16rc1.src.tar.gz"
      sha256 "6a33569f9d0d21db31614086cc2a4f0fbc683b41c1c53fb512a1341ce5763ff5"
      version "1.15.7"
    else
      url "https://golang.org/dl/go1.15.7.src.tar.gz"
      mirror "https://fossies.org/linux/misc/go1.15.7.src.tar.gz"
      sha256 "8631b3aafd8ecb9244ec2ffb8a2a8b4983cf4ad15572b9801f7c5b167c1a2abc"
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
    sha256 arm64_big_sur: "142cd5c1aaec872347771022567305de891bcfd3d5563bc66860f35f2416a1a0"
    sha256 big_sur:       "f9fafcc83029a1f568e586a8acbd95834d35b03153d6de8f9b52db97313c65d0"
    sha256 catalina:      "591f8cb8670af19adffa3917416c36d0222f0010f078851f452f8ac0305f4558"
    sha256 mojave:        "61e4f758c48b7b6cf5d302328bf34d72be2316606d1f93f4152934b874319c84"
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

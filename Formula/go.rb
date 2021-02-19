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

  resource "gobootstrap" do
    # To compile Go, you need either:
    # - an existing copy of the Go runtime
    # - a C compiler and Go 1.4, the last version of Go that was written in C.
    # Then, compile Go 1.4 using C, and use that version to compile the most
    # recent Go sources.
    #
    # With any bootstrapping compiler, there is a trust problem - you can view
    # and verify the source code, but if the compiler itself is backdoored, it
    # could propagate the backdoor into the compiled object code. For more on
    # this topic read "Reflections on Trusting Trust" by Ken Thompson.
    #
    # Verifying the compiler from scratch is slow and difficult, and Go 1.4
    # no longer compiles on recent versions of Mac OS. We choose instead
    # to trust the compiled objects available from golang.org (hosted at
    # storage.googleapis.com).
    #
    # Once we have made that choice, there's no reason to continue using an
    # older Go version to bootstrap.
    on_macos do
      if Hardware::CPU.arm?
        # Go 1.16 is the newest release that has support for ARM.
        url "https://storage.googleapis.com/golang/go1.16rc1.darwin-arm64.tar.gz"
        sha256 "f5e0fe8eddac93c79fc12c0d067fd7d119ec20facedb95029706f402334e34dd"
      else
        url "https://storage.googleapis.com/golang/go1.15.8.darwin-amd64.tar.gz"
        sha256 "7df8977d3befd2ec41479abed1c93aac93cb320dcbe4808950d28948911da854"
      end
    end

    on_linux do
      url "https://storage.googleapis.com/golang/go1.15.8.linux-amd64.tar.gz"
      sha256 "d3379c32a90fdf9382166f8f48034c459a8cc433730bc9476d39d9082c94583b"
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

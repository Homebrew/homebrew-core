class GoAT16 < Formula
  desc "Go programming environment (1.6)"
  homepage "https://golang.org"
  url "https://storage.googleapis.com/golang/go1.6.4.src.tar.gz"
  mirror "http://pkgs.fedoraproject.org/repo/pkgs/golang/go1.6.4.src.tar.gz/b023240be707b34059d2c114d3465c92/go1.6.4.src.tar.gz"
  sha256 "8796cc48217b59595832aa9de6db45f58706dae68c9c7fbbd78c9fdbe3cd9032"

  bottle do
    sha256 "0ea01c61e996e2bd88bd56f2a939ee39c05cdbc5670dc8e90be8839c90bd561f" => :sierra
    sha256 "90f9be2b14367dd4911f9dd7e3b047cc0d132c1c406d09f24d30770da908efe4" => :el_capitan
    sha256 "8707772cc1bc28c57a1a8e6a6bab71c18d93c43cd86654f016ae03480a7d5bee" => :yosemite
  end

  keg_only :versioned_formula

  option "without-cgo", "Build without cgo (also disables race detector)"
  option "without-godoc", "godoc will not be installed for you"
  option "without-race", "Build without race detector"

  resource "gotools" do
    url "https://go.googlesource.com/tools.git",
        :branch => "release-branch.go1.6"
  end

  resource "gobootstrap" do
    url "https://storage.googleapis.com/golang/go1.4-bootstrap-20161024.tar.gz"
    sha256 "398c70d9d10541ba9352974cc585c43220b6d8dbcd804ba2c9bd2fbf35fab286"
  end

  # fix build on macOS Sierra by adding compatibility for new gettimeofday behavior
  # patch derived from backported fixes to the go 1.4 release branch
  if MacOS.version == "10.12"
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/9e8273e/go%401.6/go%401.6-Sierra-build.patch"
      sha256 "9ea4feb2470f6804159b00993ba0121fec00267bb2b4f99075eb426e56a75cfc"
    end
  end

  def install
    # GOROOT_FINAL must be overidden later on real Go install
    ENV["GOROOT_FINAL"] = buildpath/"gobootstrap"

    # build the gobootstrap toolchain Go >=1.4
    (buildpath/"gobootstrap").install resource("gobootstrap")
    cd "#{buildpath}/gobootstrap/src" do
      system "./make.bash", "--no-clean"
    end

    # This should happen after we build the test Go, just in case
    # the bootstrap toolchain is aware of this variable too.
    ENV["GOROOT_BOOTSTRAP"] = ENV["GOROOT_FINAL"]
    cd "src" do
      ENV["GOROOT_FINAL"] = libexec
      ENV["GOOS"]         = "darwin"
      ENV["CGO_ENABLED"]  = "0" if build.without?("cgo")
      system "./make.bash", "--no-clean"
    end

    (buildpath/"pkg/obj").rmtree
    rm_rf "gobootstrap" # Bootstrap not required beyond compile.
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/go*"]

    # Race detector only supported on amd64 platforms.
    # https://golang.org/doc/articles/race_detector.html
    if build.with?("cgo") && build.with?("race") && MacOS.prefer_64_bit?
      system "#{bin}/go", "install", "-race", "std"
    end

    if build.with?("godoc")
      ENV.prepend_path "PATH", bin
      ENV["GOPATH"] = buildpath
      (buildpath/"src/golang.org/x/tools").install resource("gotools")

      if build.with? "godoc"
        cd "src/golang.org/x/tools/cmd/godoc/" do
          system "go", "build"
          (libexec/"bin").install "godoc"
        end
        bin.install_symlink libexec/"bin/godoc"
      end
    end
  end

  def caveats; <<~EOS
    As of go 1.2, a valid GOPATH is required to use the `go get` command:
      https://golang.org/doc/code.html#GOPATH

    You may wish to add the GOROOT-based install location to your PATH:
      export PATH=$PATH:#{opt_libexec}/bin
    EOS
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
    system "#{bin}/go", "fmt", "hello.go"
    assert_equal "Hello World\n", shell_output("#{bin}/go run hello.go")

    if build.with? "godoc"
      assert_predicate libexec/"bin/godoc", :exist?
      assert_predicate libexec/"bin/godoc", :executable?
    end
  end
end

class GoAT15 < Formula
  desc "Go programming environment (1.5)"
  homepage "https://golang.org"
  url "https://storage.googleapis.com/golang/go1.5.4.src.tar.gz"
  mirror "http://pkgs.fedoraproject.org/repo/pkgs/golang/go1.5.4.src.tar.gz/a04d570515c46e4935c63605cbd3a04e/go1.5.4.src.tar.gz"
  sha256 "002acabce7ddc140d0d55891f9d4fcfbdd806b9332fb8b110c91bc91afb0bc93"

  bottle do
    sha256 "eea38602f4f6cf0eccf586f337b4f1eb58748aa0d5b9a73ca64a2829ed5074fc" => :sierra
    sha256 "1eeeae4af5ae2fee3f6c9fa5fa2612321ab61349d8de5da574731d0705bb5a41" => :el_capitan
    sha256 "3784e41752576d79eb5fb5c3a854d0e1c90c20a38e69f5ece5cc79c340ba4ada" => :yosemite
  end

  keg_only :versioned_formula

  option "without-cgo", "Build without cgo"
  option "without-godoc", "godoc will not be installed for you"

  resource "gotools" do
    url "https://go.googlesource.com/tools.git",
        :branch => "release-branch.go1.5"
  end

  resource "gobootstrap" do
    url "https://storage.googleapis.com/golang/go1.4-bootstrap-20161024.tar.gz"
    sha256 "398c70d9d10541ba9352974cc585c43220b6d8dbcd804ba2c9bd2fbf35fab286"
  end

  # fix build on macOS Sierra by adding compatibility for new gettimeofday behavior
  # patch derived from backported fixes to the go 1.4 release branch
  if MacOS.version == "10.12"
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/ab42a22/go%401.5/go%401.5-Sierra-build.patch"
      sha256 "a21e3240fa1cb235b8f5a22e94101cdfd9d16020155d0810d546e8ad6e719791"
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

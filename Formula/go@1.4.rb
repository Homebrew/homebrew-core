class GoAT14 < Formula
  desc "Go programming environment (1.4)"
  homepage "https://golang.org"
  url "https://storage.googleapis.com/golang/go1.4.3.src.tar.gz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/go-1.4/go1.4.3.src.tar.gz"
  version "1.4.3"
  sha256 "9947fc705b0b841b5938c48b22dc33e9647ec0752bae66e50278df4f23f64959"

  bottle do
    sha256 "310b4c2b5d3a63e7d16dbac1f3d1283600171db07ec469a4b2521a313a4a8040" => :sierra
    sha256 "79e55be417a0b861ca8a72dfa368b467f64f677e399f0b57dce6f0f898dfcd12" => :el_capitan
    sha256 "1a213e281e70b4526f4d57e7aca3ef57e9a132e63ac8c713e24735720915dc59" => :yosemite
  end

  keg_only :versioned_formula

  option "with-cc-all", "Build with cross-compilers and runtime support for all supported platforms"
  option "with-cc-common", "Build with cross-compilers and runtime support for darwin, linux and windows"
  option "without-cgo", "Build without cgo"
  option "without-godoc", "godoc will not be installed for you"
  option "without-vet", "vet will not be installed for you"

  resource "gotools" do
    url "https://go.googlesource.com/tools.git",
        :branch => "release-branch.go1.4"
  end

  # fix build on macOS Sierra by adding compatibility for new gettimeofday behavior
  # patch derived from backported fixes to the go 1.4 release branch
  if MacOS.version == "10.12"
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/29ef8e9/go%401.4/go%401.4-Sierra-build.patch"
      sha256 "49c3f57432b2b3037af737c900a01822cff0a1cb440947db8507e636f6430a33"
    end
  end

  def install
    ENV.refurbish_args

    # host platform (darwin) must come last in the targets list
    if build.with? "cc-all"
      targets = [
        ["linux",   ["386", "amd64", "arm"]],
        ["freebsd", ["386", "amd64", "arm"]],
        ["netbsd",  ["386", "amd64", "arm"]],
        ["openbsd", ["386", "amd64"]],
        ["windows", ["386", "amd64"]],
        ["dragonfly", ["386", "amd64"]],
        ["plan9",   ["386", "amd64"]],
        ["solaris", ["amd64"]],
        ["darwin",  ["386", "amd64"]],
      ]
    elsif build.with? "cc-common"
      targets = [
        ["linux",   ["386", "amd64", "arm"]],
        ["windows", ["386", "amd64"]],
        ["darwin",  ["386", "amd64"]],
      ]
    else
      targets = [["darwin", [""]]]
    end

    cd "src" do
      targets.each do |os, archs|
        archs.each do |arch|
          ENV["GOROOT_FINAL"] = libexec
          ENV["GOOS"]         = os
          ENV["GOARCH"]       = arch
          ENV["CGO_ENABLED"]  = "0" if build.without?("cgo")
          ohai "Building go for #{arch}-#{os}"
          system "./make.bash", "--no-clean"
        end
      end
    end

    (buildpath/"pkg/obj").rmtree
    libexec.install Dir["*"]
    (bin/"go").write_env_script(libexec/"bin/go", :PATH => "#{libexec}/bin:$PATH")
    bin.install_symlink libexec/"bin/gofmt"

    if build.with?("godoc") || build.with?("vet")
      ENV.prepend_path "PATH", libexec/"bin"
      ENV["GOPATH"] = buildpath
      (buildpath/"src/golang.org/x/tools").install resource("gotools")

      if build.with? "godoc"
        cd "src/golang.org/x/tools/cmd/godoc/" do
          system "go", "build"
          (libexec/"bin").install "godoc"
        end
        bin.install_symlink libexec/"bin/godoc"
      end

      if build.with? "vet"
        cd "src/golang.org/x/tools/cmd/vet/" do
          system "go", "build"
          # This is where Go puts vet natively; not in the bin.
          (libexec/"pkg/tool/darwin_amd64/").install "vet"
        end
      end
    end
  end

  def caveats; <<-EOS.undent
    As of go 1.2, a valid GOPATH is required to use the `go get` command:
      https://golang.org/doc/code.html#GOPATH

    You may wish to add the GOROOT-based install location to your PATH:
      export PATH=$PATH:#{opt_libexec}/bin
    EOS
  end

  test do
    (testpath/"hello.go").write <<-EOS.undent
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
      assert File.exist?(libexec/"bin/godoc")
      assert File.executable?(libexec/"bin/godoc")
    end

    if build.with? "vet"
      assert File.exist?(libexec/"pkg/tool/darwin_amd64/vet")
      assert File.executable?(libexec/"pkg/tool/darwin_amd64/vet")
    end
  end
end

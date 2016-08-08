class Go < Formula
  desc "Go programming environment"
  homepage "https://golang.org"

  stable do
    url "https://storage.googleapis.com/golang/go1.6.3.src.tar.gz"
    mirror "https://fossies.org/linux/misc/go1.6.3.src.tar.gz"
    version "1.6.3"
    sha256 "6326aeed5f86cf18f16d6dc831405614f855e2d416a91fd3fdc334f772345b00"

    # 1.6.3 does not build on macOS Sierra. Users should use devel instead
    # until 1.7 is stable (due soon).
    depends_on MaximumMacOSRequirement => :el_capitan

    # Should use the last stable binary release to bootstrap.
    resource "gobootstrap" do
      url "https://storage.googleapis.com/golang/go1.6.2.darwin-amd64.tar.gz"
      version "1.6.2"
      sha256 "6ebbafcac53bbbf8c4105fa84b63cca3d6ce04370f5a04ac2ac065782397fc26"
    end

    go_version = "1.6"
    resource "gotools" do
      url "https://go.googlesource.com/tools.git",
          :branch => "release-branch.go#{go_version}",
          :revision => "c887be1b2ebd11663d4bf2fbca508c449172339e"
    end
  end

  bottle do
    revision 1
    sha256 "f06ee1c467cdaa7574ebfc52dad2941b65e349266e1e42ff788383c55b1db7d1" => :el_capitan
    sha256 "1a849c88620cdaf0c8772ff1e57e3f22d2c9ca7dc2533de479334c492b7200e7" => :yosemite
    sha256 "5f570b6c7aa2d7caa6c715af6dce6fa30d7fbd5acc46fac8fbc3232270956f9e" => :mavericks
  end

  devel do
    url "https://storage.googleapis.com/golang/go1.7rc6.src.tar.gz"
    version "1.7rc6"
    sha256 "a289943548b838c7ef606a37836d1db080a3cb3c6df4e76456e23609b8505d05"

    # Should use the last stable binary release to bootstrap.
    # Not the case here because 1.6.3 is lacking a fix for an issue which breaks
    # compile on macOS Sierra; in future this should share bootstrap with stable.
    resource "gobootstrap" do
      url "https://storage.googleapis.com/golang/go1.7rc6.darwin-amd64.tar.gz"
      version "1.7rc6"
      sha256 "ffe440747f7c663d7fc276b167ac630f921e66674c9952c97eed26fea9c8ac58"
    end

    go_version = "1.7"
    resource "gotools" do
      url "https://go.googlesource.com/tools.git",
          :branch => "release-branch.go#{go_version}",
          :revision => "a84e830bb0d2811304f6e66498eb3123ca97b68e"
    end
  end

  head do
    url "https://github.com/golang/go.git"

    # Should use the last stable binary release to bootstrap.
    # See devel for notes as to why not the case here, for now.
    resource "gobootstrap" do
      url "https://storage.googleapis.com/golang/go1.7rc6.darwin-amd64.tar.gz"
      version "1.7rc6"
      sha256 "ffe440747f7c663d7fc276b167ac630f921e66674c9952c97eed26fea9c8ac58"
    end

    resource "gotools" do
      url "https://go.googlesource.com/tools.git"
    end
  end

  option "without-cgo", "Build without cgo"
  option "without-godoc", "godoc will not be installed for you"
  option "without-vet", "vet will not be installed for you"
  option "without-race", "Build without race detector"

  depends_on :macos => :mountain_lion

  def install
    (buildpath/"gobootstrap").install resource("gobootstrap")
    ENV["GOROOT_BOOTSTRAP"] = buildpath/"gobootstrap"

    cd "src" do
      ENV["GOROOT_FINAL"] = libexec
      ENV["GOOS"]         = "darwin"
      ENV["CGO_ENABLED"]  = build.with?("cgo") ? "1" : "0"
      system "./make.bash", "--no-clean"
    end

    (buildpath/"pkg/obj").rmtree
    rm_rf "gobootstrap" # Bootstrap not required beyond compile.
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/go*"]

    # Race detector only supported on amd64 platforms.
    # https://golang.org/doc/articles/race_detector.html
    if MacOS.prefer_64_bit? && build.with?("race")
      system "#{bin}/go", "install", "-race", "std"
    end

    if build.with?("godoc") || build.with?("vet")
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

      # go vet is now part of the standard Go toolchain. Remove this block
      # and the option once Go 1.7 is released
      if build.with?("vet") && File.exist?("src/golang.org/x/tools/cmd/vet/")
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

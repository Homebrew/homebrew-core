class Go < Formula
  desc "Go programming environment"
  homepage "https://golang.org"

  stable do
    url "https://storage.googleapis.com/golang/go1.6.3.src.tar.gz"
    mirror "https://fossies.org/linux/misc/go1.6.3.src.tar.gz"
    version "1.6.3"
    sha256 "6326aeed5f86cf18f16d6dc831405614f855e2d416a91fd3fdc334f772345b00"

    go_version = "1.6"
    resource "gotools" do
      url "https://go.googlesource.com/tools.git",
          :branch => "release-branch.go#{go_version}",
          :revision => "c887be1b2ebd11663d4bf2fbca508c449172339e"
    end
  end

  bottle do
    sha256 "54159189e4779b8c34235bd3f18c62122b4826f478a0a6c9812fbcce608849bf" => :el_capitan
    sha256 "597524370e994f7d153e6ae20ed28a4ad9fee1ea9e2d8a7b29674699a52ae601" => :yosemite
    sha256 "41a1322a0c302b9d7c74788f7d57cffc1296b627e77165507106412b3932d44a" => :mavericks
  end

  devel do
    url "https://storage.googleapis.com/golang/go1.7rc3.src.tar.gz"
    version "1.7rc3"
    sha256 "6df6425ec3ac23fe9bcc52e1950f3a5829e5ed5a964d396d7f662a3d2fa95232"

    go_version = "1.7"
    resource "gotools" do
      url "https://go.googlesource.com/tools.git",
          :branch => "release-branch.go#{go_version}",
          :revision => "a84e830bb0d2811304f6e66498eb3123ca97b68e"
    end
  end

  head do
    url "https://github.com/golang/go.git"

    resource "gotools" do
      url "https://go.googlesource.com/tools.git"
    end
  end

  option "without-cgo", "Build without cgo"
  option "without-godoc", "godoc will not be installed for you"
  option "without-vet", "vet will not be installed for you"
  option "without-race", "Build without race detector"

  resource "gobootstrap" do
    if MacOS.version > :lion
      url "https://storage.googleapis.com/golang/go1.4.2.darwin-amd64-osx10.8.tar.gz"
      sha256 "c2f53983fc8fe5159d811081022ebc401b8111759ce008f91193abdae82cdbc9"
    else
      url "https://storage.googleapis.com/golang/go1.4.2.darwin-amd64-osx10.6.tar.gz"
      sha256 "da40e85a2c9bda9d2c29755c8b57b8d5932440ba466ca366c2a667697a62da4c"
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

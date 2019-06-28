class GoAT111 < Formula
  desc "Go programming environment (1.11)"
  homepage "https://golang.org"
  url "https://dl.google.com/go/go1.11.6.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.11.6.src.tar.gz"
  sha256 "a96da1425dcbec094736033a8a416316547f8100ab4b72c31d4824d761d3e133"

  bottle do
    rebuild 2
    sha256 "7d444e90e02df64ca6763686ec4d5f101b6773e63ad29a3d21b396fcbe2a52e5" => :mojave
    sha256 "4c4f77da4340781b2b950be37d612fa2ba45b41d8999ecb76166da80e11622a2" => :high_sierra
    sha256 "65f35010e6ad1cf6fbf642e8cbac49b9d24e82d2fa8d3d78e0ade383a5000699" => :sierra
  end

  keg_only :versioned_formula

  depends_on :macos => :yosemite

  resource "gotools" do
    url "https://go.googlesource.com/tools.git",
        :branch => "release-branch.go1.11"
  end

  # Don't update this unless this version cannot bootstrap the new version.
  resource "gobootstrap" do
    url "https://storage.googleapis.com/golang/go1.7.darwin-amd64.tar.gz"
    version "1.7"
    sha256 "51d905e0b43b3d0ed41aaf23e19001ab4bc3f96c3ca134b48f7892485fc52961"
  end

  # Prevents Go from building malformed binaries. Fixed upstream, should
  # be in a future release.
  # https://github.com/golang/go/issues/32673
  patch do
    url "https://github.com/golang/go/commit/26954bde4443c4bfbfe7608f35584b6b810f3f2c.patch?full_index=1"
    sha256 "25a361bd4aa1155be06e2239c1974aa9c59f971210f19e16a3b7b576b9d4f677"
  end

  patch do
    url "https://github.com/golang/go/commit/0fe1986a72ea578390d4909988a1d7cb3a687544.patch?full_index=1"
    sha256 "320c11208313fc74e0bba7f323791416e5316451b109c440f56be361df8306ea"
  end

  patch do
    url "https://github.com/golang/go/commit/3f1422c799edb143303c86c0e875d44c3612df64.patch?full_index=1"
    sha256 "d071f0415cd2712cbed373682c4a84661147df1aabf38bbc0f3179532a988a4f"
  end

  def install
    (buildpath/"gobootstrap").install resource("gobootstrap")
    ENV["GOROOT_BOOTSTRAP"] = buildpath/"gobootstrap"

    cd "src" do
      ENV["GOROOT_FINAL"] = libexec
      ENV["GOOS"]         = "darwin"
      system "./make.bash", "--no-clean"
    end

    (buildpath/"pkg/obj").rmtree
    rm_rf "gobootstrap" # Bootstrap not required beyond compile.
    libexec.install Dir["*"]
    bin.install_symlink Dir[libexec/"bin/go*"]

    system bin/"go", "install", "-race", "std"

    # Build and install godoc
    ENV.prepend_path "PATH", bin
    ENV["GO111MODULE"] = "on"
    ENV["GOPATH"] = buildpath
    (buildpath/"src/golang.org/x/tools").install resource("gotools")
    cd "src/golang.org/x/tools/cmd/godoc/" do
      system "go", "build"
      (libexec/"bin").install "godoc"
    end
    bin.install_symlink libexec/"bin/godoc"
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
    system bin/"go", "build", "hello.go"
  end
end

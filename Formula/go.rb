class Go < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://golang.org"

  stable do
    url "https://dl.google.com/go/go1.12.6.src.tar.gz"
    mirror "https://fossies.org/linux/misc/go1.12.6.src.tar.gz"
    sha256 "c96c5ccc7455638ae1a8b7498a030fe653731c8391c5f8e79590bce72f92b4ca"

    go_version = version.to_s.split(".")[0..1].join(".")
    resource "gotools" do
      url "https://go.googlesource.com/tools.git",
          :branch => "release-branch.go#{go_version}"
    end
  end

  bottle do
    rebuild 1
    sha256 "96df07e3a2dcdc01a9ac8c35af2f33d2a7f9c8903787f991c0fbbc2aa8270194" => :mojave
    sha256 "a4dc6ccab9265f5568eb39fbf62e759abe9a15f6c1026c88831cee0627de86b3" => :high_sierra
    sha256 "9b8cede35a5ed81b8dc1a817d031d7f542a7202eb77ad61416e70076d28ff19d" => :sierra
  end

  head do
    url "https://go.googlesource.com/go.git"

    resource "gotools" do
      url "https://go.googlesource.com/tools.git"
    end
  end

  depends_on :macos => :yosemite

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

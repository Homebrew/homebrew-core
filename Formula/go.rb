class Go < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.20.1.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.20.1.src.tar.gz"
  sha256 "b5c1a3af52c385a6d1c76aed5361cf26459023980d0320de7658bae3915831a2"
  license "BSD-3-Clause"
  head "https://go.googlesource.com/go.git", branch: "master"

  livecheck do
    url "https://go.dev/dl/"
    regex(/href=.*?go[._-]?v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "06c654ce03d10b461b1d801af9ac6bebcaf64b1233a5c0ca63548120fc256e1c"
    sha256 arm64_monterey: "ec459d67edb1e0b6fcd1d5096818d8b23e7feb1af7f6af85f2bfcb5ebf241581"
    sha256 arm64_big_sur:  "7c0ee58dfd0777cdec099a1c8297046b97cb61a75f0353778fd3aa70b24c572a"
    sha256 ventura:        "da9f7ac40f8d10c7342188528533c9cc12344c5abb8d802496954203c6edfb56"
    sha256 monterey:       "268da7cba4b4f237999ba82a8641c1e90209041115a5acd74beed0686e1746d1"
    sha256 big_sur:        "b920f6a578c0603f880731b1263bec8940276f15b2ce7bb9278fcb22fde7c5df"
    sha256 x86_64_linux:   "12dbd768192798736314681ec88d7ce7d3dc7257b0829968596129694cc4265b"
  end

  # Don't update this unless this version cannot bootstrap the new version.
  resource "gobootstrap" do
    checksums = {
      "darwin-arm64" => "e4ccc9c082d91eaa0b866078b591fc97d24b91495f12deb3dd2d8eda4e55a6ea",
      "darwin-amd64" => "c101beaa232e0f448fab692dc036cd6b4677091ff89c4889cc8754b1b29c6608",
      "linux-arm64"  => "914daad3f011cc2014dea799bb7490442677e4ad6de0b2ac3ded6cee7e3f493d",
      "linux-amd64"  => "4cdd2bc664724dc7db94ad51b503512c5ae7220951cac568120f64f8e94399fc",
    }

    arch = "arm64"
    platform = "darwin"

    on_intel do
      arch = "amd64"
    end

    on_linux do
      platform = "linux"
    end

    boot_version = "1.17.13"

    url "https://storage.googleapis.com/golang/go#{boot_version}.#{platform}-#{arch}.tar.gz"
    version boot_version
    sha256 checksums["#{platform}-#{arch}"]
  end

  def install
    (buildpath/"gobootstrap").install resource("gobootstrap")
    ENV["GOROOT_BOOTSTRAP"] = buildpath/"gobootstrap"

    cd "src" do
      ENV["GOROOT_FINAL"] = libexec
      system "./make.bash"
    end

    rm_rf "gobootstrap" # Bootstrap not required beyond compile.
    libexec.install Dir["*"]
    bin.install_symlink Dir[libexec/"bin/go*"]

    system bin/"go", "install", "-race", "std"

    # Remove useless files.
    # Breaks patchelf because folder contains weird debug/test files
    (libexec/"src/debug/elf/testdata").rmtree
    # Binaries built for an incompatible architecture
    (libexec/"src/runtime/pprof/testdata").rmtree
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

    ENV["GOOS"] = "freebsd"
    ENV["GOARCH"] = "amd64"
    system bin/"go", "build", "hello.go"
  end
end

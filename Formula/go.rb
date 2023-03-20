class Go < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.20.2.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.20.2.src.tar.gz"
  sha256 "4d0e2850d197b4ddad3bdb0196300179d095bb3aefd4dfbc3b36702c3728f8ab"
  license "BSD-3-Clause"
  head "https://go.googlesource.com/go.git", branch: "master"

  livecheck do
    url "https://go.dev/dl/"
    regex(/href=.*?go[._-]?v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "3517ed5d96d5a40cd4c44a35f7799a239b82d9855a6799c6f60193768f9825cd"
    sha256 arm64_monterey: "3517ed5d96d5a40cd4c44a35f7799a239b82d9855a6799c6f60193768f9825cd"
    sha256 arm64_big_sur:  "3517ed5d96d5a40cd4c44a35f7799a239b82d9855a6799c6f60193768f9825cd"
    sha256 ventura:        "ea6a2d446679fd9bc460425f3fce2e1c4a27504c6e6ad2cd9c8f7380fc75988a"
    sha256 monterey:       "ea6a2d446679fd9bc460425f3fce2e1c4a27504c6e6ad2cd9c8f7380fc75988a"
    sha256 big_sur:        "ea6a2d446679fd9bc460425f3fce2e1c4a27504c6e6ad2cd9c8f7380fc75988a"
    sha256 x86_64_linux:   "dabdff435af1ef8289dbfe4313cb190f5c61cb46b3b845b37d79beaf38c2434b"
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

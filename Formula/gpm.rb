class Gpm < Formula
  desc "Barebones dependency manager for Go"
  homepage "https://github.com/pote/gpm"
  url "https://github.com/pote/gpm/archive/v1.4.0.tar.gz"
  sha256 "2e213abbb1a12ecb895c3f02b74077d3440b7ae3221b4b524659c2ea9065b02a"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "171a1566f1c3d0c843f39878cd64d4ca74dd3491536616f3ca49c86cb71d8ee2"
    sha256 cellar: :any_skip_relocation, big_sur:       "50e9ac019049016b8d3e220ef38e3d8bba8f184b1797a5efa967a19ca088361b"
    sha256 cellar: :any_skip_relocation, catalina:      "f5c138e505b9e96ca109152ab5e5aa6871d9e9b200b7c603ca4d1c210be30838"
    sha256 cellar: :any_skip_relocation, mojave:        "d13ab2f5674bb5797801ca42fc50ff05ecfc9f674d09a406e8affcce2baf4111"
    sha256 cellar: :any_skip_relocation, high_sierra:   "cac9f1ce7bb82555763015539417c9e709ca27d414c24f100ed045b593573cee"
    sha256 cellar: :any_skip_relocation, sierra:        "816976b12502697adb886dfbee31bbc2cfcbe2cff1302927f8da6cef4e4b08cf"
    sha256 cellar: :any_skip_relocation, el_capitan:    "ba26a6b34e92b4333d636ae3d9e54d726f6bd3bbabdabbfbdd9c3fec569e10fe"
    sha256 cellar: :any_skip_relocation, yosemite:      "0ed200c92c086eebf306065403c6a18db6e55e6d2764904cbd53f442f3043179"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02b1f03f80d4477e80aaa5b1cc62e9a4be9288f4d4116a23c386bb9b6fcd3906"
    sha256 cellar: :any_skip_relocation, all:           "02b1f03f80d4477e80aaa5b1cc62e9a4be9288f4d4116a23c386bb9b6fcd3906"
  end

  depends_on "go"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["GOPATH"] = testpath
    ENV["GO111MODULE"] = "auto"
    (testpath/"Godeps").write("github.com/pote/gpm-testing-package v6.1")
    system bin/"gpm", "install"
    (testpath/"go_code.go").write <<~EOS
      package main
      import ("fmt"; "github.com/pote/gpm-testing-package")
      func main() { fmt.Print(gpm_testing_package.Version()) }
    EOS
    assert_equal "v6.1", shell_output("go run go_code.go")
  end
end

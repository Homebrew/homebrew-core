class Gpm < Formula
  desc "Barebones dependency manager for Go"
  homepage "https://github.com/pote/gpm"
  url "https://github.com/pote/gpm/archive/v1.4.0.tar.gz"
  sha256 "2e213abbb1a12ecb895c3f02b74077d3440b7ae3221b4b524659c2ea9065b02a"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "d13ab2f5674bb5797801ca42fc50ff05ecfc9f674d09a406e8affcce2baf4111" => :mojave
    sha256 "cac9f1ce7bb82555763015539417c9e709ca27d414c24f100ed045b593573cee" => :high_sierra
    sha256 "816976b12502697adb886dfbee31bbc2cfcbe2cff1302927f8da6cef4e4b08cf" => :sierra
    sha256 "ba26a6b34e92b4333d636ae3d9e54d726f6bd3bbabdabbfbdd9c3fec569e10fe" => :el_capitan
    sha256 "0ed200c92c086eebf306065403c6a18db6e55e6d2764904cbd53f442f3043179" => :yosemite
    sha256 "87cf43901daa271a5d27fbea5e6f103c15e287318152f02f0ef14bd77d51cb63" => :mavericks
  end

  depends_on "go"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["GOPATH"] = testpath
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

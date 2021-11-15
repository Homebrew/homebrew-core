class Fileicon < Formula
  desc "macOS CLI for managing custom icons for files and folders"
  homepage "https://github.com/mklement0/fileicon"
  url "https://github.com/mklement0/fileicon/archive/v0.2.4.tar.gz"
  sha256 "c7a2996bf41b5cdd8d3a256f2b97724775c711a1a413fd53b43409ef416db35a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "74fd8797923e791df971d389dd62649a8717a60fa6108677bec35628a8216fab"
    sha256 cellar: :any_skip_relocation, big_sur:       "1ea828e58968967a95fdf3ece8ffa79b4bbe5b984e942c6db50119e4befb1b8d"
    sha256 cellar: :any_skip_relocation, catalina:      "154c80c94f29f209b78252e71d914647a8300c66c02acda672b8574e8e704e92"
    sha256 cellar: :any_skip_relocation, mojave:        "154c80c94f29f209b78252e71d914647a8300c66c02acda672b8574e8e704e92"
    sha256 cellar: :any_skip_relocation, high_sierra:   "154c80c94f29f209b78252e71d914647a8300c66c02acda672b8574e8e704e92"
    sha256 cellar: :any_skip_relocation, all:           "404d155d24d4d6ca2d55f60dfadb8e267927ad7200c297e87337bab641f8c137"
  end

  depends_on :macos

  def install
    bin.install "bin/fileicon"
    man1.install "man/fileicon.1"
  end

  test do
    icon = test_fixtures "test.png"
    system bin/"fileicon", "set", testpath, icon
    assert_predicate testpath/"Icon\r", :exist?
    stdout = shell_output "#{bin}/fileicon test #{testpath}"
    assert_includes stdout, "HAS custom icon: '#{testpath}'"
  end
end

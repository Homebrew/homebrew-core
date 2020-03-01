class Fileicon < Formula
  desc "macOS CLI for managing custom icons for files and folders"
  homepage "https://github.com/mklement0/fileicon"
  url "https://github.com/mklement0/fileicon/archive/v0.2.4.tar.gz"
  sha256 "c7a2996bf41b5cdd8d3a256f2b97724775c711a1a413fd53b43409ef416db35a"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b3cfdf0e341c2a39ff84e617279e95f38d315130ed2820d867251ef4c8ba9da" => :catalina
    sha256 "6b3cfdf0e341c2a39ff84e617279e95f38d315130ed2820d867251ef4c8ba9da" => :mojave
    sha256 "6b3cfdf0e341c2a39ff84e617279e95f38d315130ed2820d867251ef4c8ba9da" => :high_sierra
  end

  def install
    bin.install "bin/fileicon"
    man1.install "man/fileicon.1"
  end

  test do
    icon = test_fixtures "test.png"
    system bin/"fileicon", "set", testpath, icon
    assert_predicate testpath/"Icon\r", :exist?
    stdout = shell_output "#{bin}/fileicon test #{testpath}"
    assert_include stdout, "HAS custom icon: '#{testpath}'"
  end
end

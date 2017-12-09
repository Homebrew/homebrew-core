class Ohcount < Formula
  desc "Source code line counter"
  homepage "https://github.com/blackducksw/ohcount"
  url "https://github.com/blackducksw/ohcount/archive/v3.1.0.tar.gz"
  sha256 "1b7bef72ea5d75c99ea46d219f2d7350b716738fb07dda31e2099a8e0c00e329"
  head "https://github.com/blackducksw/ohcount.git"

  bottle do
    cellar :any
    sha256 "2aa51a2ba598bdbebf93f3e4f6219a5fb462ef4bb473e4c7bf147e4f3ed69c2d" => :high_sierra
    sha256 "18d38ed705047709d1ceb735c25f467f96d8cdd4d8a37ea6c88b1776affdfb8b" => :sierra
    sha256 "7f48accbf977a34b5d3c818706606f1f91b457f9762ecc9844f917d5927ea9f8" => :el_capitan
  end

  depends_on "libmagic"
  depends_on "pcre"
  depends_on "ragel"

  def install
    system "./build", "ohcount"
    bin.install "bin/ohcount"
  end

  test do
    (testpath/"test.rb").write <<~EOS
      # comment
      puts
      puts
    EOS
    stats = shell_output("#{bin}/ohcount -i test.rb").lines.last
    assert_equal ["ruby", "2", "1", "33.3%"], stats.split[0..3]
  end
end

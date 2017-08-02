class Cmark < Formula
  desc "Strongly specified, highly compatible implementation of Markdown"
  homepage "http://commonmark.org"
  url "https://github.com/jgm/cmark/archive/0.28.0.tar.gz"
  sha256 "68cf191f4a78494a43b7e1663506635e370f0ba4c67c9ee9518e295685bbfe0e"

  bottle do
    cellar :any
    sha256 "36c98518b406ac0110ca0652cfd16a375e025ec8d61580e8b4e7b6f6a6e07029" => :sierra
    sha256 "9438f3ef25eadaa7536178a344eb966772717dd5c15441995a3af41c77680e55" => :el_capitan
    sha256 "4af3edaaaee4e24285dd1faf39c85d5e31ad3964086b3208d18224a3ebaf8348" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on :python3 => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "test"
      system "make", "install"
    end
  end

  test do
    output = pipe_output("#{bin}/cmark", "*hello, world*")
    assert_equal "<p><em>hello, world</em></p>", output.chomp
  end
end

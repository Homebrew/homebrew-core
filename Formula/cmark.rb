class Cmark < Formula
  desc "Strongly specified, highly compatible implementation of Markdown"
  homepage "http://commonmark.org"
  url "https://github.com/jgm/cmark/archive/0.27.1.tar.gz"
  sha256 "669b4c19355e8cb90139fdd03b02283b97130e92ea99a104552a2976751446b5"

  bottle do
    cellar :any
    sha256 "c170c30546ae596ce2ae8374cc3c900e2971ea3aa8a3a9b09919ab4fd1e9ba9e" => :sierra
    sha256 "ec4d5c1f9c16034b9ef5062f811cff74d4f2645de3c63ee3cd476ba9ded9d08c" => :el_capitan
    sha256 "ea9675567a43a93b908d5086ba48820ee3c46cbe411bc45bc93acd467b2bd568" => :yosemite
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

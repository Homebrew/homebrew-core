class Cmark < Formula
  desc "Strongly specified, highly compatible implementation of Markdown"
  homepage "http://commonmark.org"
  url "https://github.com/jgm/cmark/archive/0.26.1.tar.gz"
  sha256 "b50615a97f9c19e353d65f3bdbd6898ed1443a6f49e38f0aa888d5b58867f5d6"

  bottle do
    cellar :any
    sha256 "98a7a59ab704bd4f73ea13aab5e5e728c536657c115fd6fa5074f081f739fb55" => :sierra
    sha256 "5df622e01450936300ed1d69eded3bd6ecd3b5bab4b57c7c8ee87822b41fa28d" => :el_capitan
    sha256 "ed3b5eb6d3a5c55bb3c1c75848a8439db6a30de7322db0c12075e218aaef25cb" => :yosemite
    sha256 "4797178f1c1360fc53a115d6760b5d677707204ae588fa848ce869d58ae35bf4" => :mavericks
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

class Cmark < Formula
  desc "Strongly specified, highly compatible implementation of Markdown"
  homepage "http://commonmark.org"
  url "https://github.com/jgm/cmark/archive/0.26.1.tar.gz"
  sha256 "b50615a97f9c19e353d65f3bdbd6898ed1443a6f49e38f0aa888d5b58867f5d6"

  bottle do
    cellar :any
    sha256 "f74ef1e2939171993a67d17cd08d27a6293aa27c93b65ab1af5e110015426013" => :el_capitan
    sha256 "6fa78722a84775b2ff9d2698d6715bf3ec048ed81dbe9326661ee9f5dfa00abe" => :yosemite
    sha256 "2a032145606f1c0b20ab7bebc5ad61235c1ce1ca1db3ea084d7671b4e6698498" => :mavericks
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

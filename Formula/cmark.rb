class Cmark < Formula
  desc "Strongly specified, highly compatible implementation of Markdown"
  homepage "http://commonmark.org"
  url "https://github.com/jgm/cmark/archive/0.26.0.tar.gz"
  sha256 "7ed32e77966c5d06cd6f010b46894cd4d1f494651d6e0da55cb876436fdac806"

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
      system "make", "install"
    end
  end

  test do
    test_input = "*hello, world*\n"
    expected_output = "<p><em>hello, world</em></p>\n"
    test_output = `/bin/echo -n "#{test_input}" | #{bin}/cmark`
    assert_equal expected_output, test_output
  end
end

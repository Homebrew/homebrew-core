class Cmark < Formula
  desc "Strongly specified, highly compatible implementation of Markdown"
  homepage "http://commonmark.org"
  url "https://github.com/jgm/cmark/archive/0.28.3.tar.gz"
  sha256 "acc98685d3c1b515ff787ac7c994188dadaf28a2d700c10c1221da4199bae1fc"

  bottle do
    cellar :any
    sha256 "9c2e69133dde99b52edcaed19894de24293871f0a1140edced7eefa1b35046db" => :high_sierra
    sha256 "54f604e8e1650729df23be204267e63709e83d27cd25ec3cb0c1cac2da803f0f" => :sierra
    sha256 "4bc34f60ec9f020810df1cc96362797930fc4bc2531c44228cf15a4fe9ef4f72" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on :python3 => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DCMAKE_INSTALL_LIBDIR=lib", *std_cmake_args
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

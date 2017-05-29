class CmarkGfm < Formula
  desc "C implementation of GitHub Flavored Markdown"
  homepage "https://github.com/github/cmark"
  url "https://github.com/github/cmark/archive/0.27.1.gfm.1.tar.gz"
  version "0.27.1.gfm.1"
  sha256 "acf5d9f10379ca64b6dc5a42dea907bac7a7d9646d1901767d984338fbcf5159"

  bottle do
    cellar :any
    sha256 "7979512a739963b80fc16dc98136d9af1be6b817e75dd2113c2a8cc633f904dd" => :sierra
    sha256 "0301b8b6da0e11160b8b936ec6767b3c349daa988e007a7e11e17efb367f9cc4" => :el_capitan
    sha256 "a1a9be204b4f7f2508e3c0e2302860566414a3f051cef71871a464d3ce2f7226" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on :python3 => :build

  conflicts_with "cmark", :because => "both install a `cmark.h` header"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "test"
      system "make", "install"
    end
  end

  test do
    output = pipe_output("#{bin}/cmark-gfm --extension autolink", "https://brew.sh")
    assert_equal '<p><a href="https://brew.sh">https://brew.sh</a></p>', output.chomp
  end
end

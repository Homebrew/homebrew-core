class Glyr < Formula
  desc "Music related metadata search engine with command-line interface and C API"
  homepage "https://github.com/sahib/glyr"
  url "https://github.com/sahib/glyr/archive/1.0.10.tar.gz"
  sha256 "77e8da60221c8d27612e4a36482069f26f8ed74a1b2768ebc373c8144ca806e8"
  revision 1

  bottle do
    cellar :any
    sha256 "0a32bfceb64d33842aee008ca44e823062589323777efee2f15f013f18017a08" => :catalina
    sha256 "45d36208e031f97c1202824c6a6a0a9e97d777fae91ce7cddc3ca17c3168d31c" => :mojave
    sha256 "fb3ef9186aae754a62a466aae16471049bdaefcc168106fc6f0097e937115524" => :high_sierra
    sha256 "04cbfc6d3294d068b3a97bfb5235aed84b3e95478f8f3e873be17127142b07f6" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    search = "--artist Beatles --album \"Please Please Me\""
    cmd = "#{bin}/glyrc cover --no-download #{search} -w stdout"
    assert_match %r{^https?://}, pipe_output(cmd, nil, 0)
  end
end

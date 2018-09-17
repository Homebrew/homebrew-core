class Glyr < Formula
  desc "Music related metadata search engine with command-line interface and C API"
  homepage "https://github.com/sahib/glyr"
  url "https://github.com/sahib/glyr/archive/1.0.10.tar.gz"
  sha256 "77e8da60221c8d27612e4a36482069f26f8ed74a1b2768ebc373c8144ca806e8"

  bottle do
    cellar :any
    sha256 "7bfffde1ce6a9cd213e242502abb7a0339d1a41cdb0b602f654a5cba29ef719c" => :mojave
    sha256 "9b7448df01aa5a4c2971d627ebd119fe59ab6c37ad1ded6f1471037a3af3d820" => :high_sierra
    sha256 "66daab90aa98c16fa6e3c031e4036ccb7f41f133212f6fff004bcede05dd42b7" => :sierra
    sha256 "3a015fb80957abdedfcbaccff3f614653f62b1154cec1ee59eb7f34f8f060071" => :el_capitan
    sha256 "3be5650f4bc70c13e62c3092aef3629357e68424485590304de80345c6a817e1" => :yosemite
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

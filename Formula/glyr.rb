class Glyr < Formula
  desc "Music related metadata search engine with command-line interface and C API"
  homepage "https://github.com/sahib/glyr"
  url "https://github.com/sahib/glyr/archive/1.0.9.tar.gz"
  sha256 "b2be2d51ba4a8f2bf83d4af8f2491c24b5090c561b72bb3ee319995023678aed"

  bottle do
    cellar :any
    sha256 "1ad972684bd9c9a30cec00852d1091ad0c7c07d6affc5e7b38f762cdd4b91c7c" => :sierra
    sha256 "d734d6df100a1fce794cf3a4369f209d8ef3035bde0396a857f116b58945b229" => :el_capitan
    sha256 "f7f98aaa44e4132985579133546abb0f7ef4a7fc2e12f1f438950835b10efd86" => :yosemite
    sha256 "57679677a24b330752690f30172d8fc187363cb7109b2368ea26996840a3bf21" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gettext"

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

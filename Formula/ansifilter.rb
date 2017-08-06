class Ansifilter < Formula
  desc "Strip or convert ANSI codes into HTML, (La)Tex, RTF, or BBCode"
  homepage "http://www.andre-simon.de/doku/ansifilter/ansifilter.html"
  url "http://www.andre-simon.de/zip/ansifilter-2.8.tar.bz2"
  sha256 "0d35842076f7931aed5d08447104d3ad134840bbef5ffed88f0701951dea049b"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d1d5e2b75fbe633a78d16432565ca55b43cdd276d786a2e0df94c59f65fe8ac" => :sierra
    sha256 "e6e383bfc04a1300a637c407fdfeee42507fdec5ed769b1ad6b4ce4045e59d62" => :el_capitan
    sha256 "fd59a13bdc099570073f3b9c50677433b11ce26cf161695dd120d8d8469a007c" => :yosemite
  end

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    path = testpath/"ansi.txt"
    path.write "f\x1b[31moo"

    assert_equal "foo", shell_output("#{bin}/ansifilter #{path}").strip
  end
end

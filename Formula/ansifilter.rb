class Ansifilter < Formula
  desc "Strip or convert ANSI codes into HTML, (La)Tex, RTF, or BBCode"
  homepage "http://www.andre-simon.de/doku/ansifilter/ansifilter.html"
  url "http://www.andre-simon.de/zip/ansifilter-2.5.tar.bz2"
  sha256 "30d05ccfa9be98b0328ee29fe39473e55047f1d32a9a2460d3d4d1ff2475f0e2"

  bottle do
    cellar :any_skip_relocation
    sha256 "72b1165dcfbe32608cd66e338d699bcf1bb3b484d0e7d8bcf4a60f9b40e942fc" => :sierra
    sha256 "a4224e9f94a2f5dd72ee72e37f19de493420f686846350c62259bd18e71c49f2" => :el_capitan
    sha256 "8e8cc89775c4ba044958da52448d3406f252888459e06af99876858794fa740a" => :yosemite
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

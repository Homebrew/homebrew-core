class Ansifilter < Formula
  desc "Strip or convert ANSI codes into HTML, (La)Tex, RTF, or BBCode"
  homepage "http://www.andre-simon.de/doku/ansifilter/ansifilter.html"
  url "http://www.andre-simon.de/zip/ansifilter-2.7.tar.bz2"
  sha256 "6e844a21186a2011601aa87b37863fd946572bd86bbb145842ffa54c55bb4ecd"

  bottle do
    cellar :any_skip_relocation
    sha256 "a6bd588b31378141b7ee60992ee719c9bae1b263b9e986d3a517ffeddb40725b" => :sierra
    sha256 "05b1549a9cf14dc57a6d5e58eb4624e5618d989c143609d1cb9a03682e673908" => :el_capitan
    sha256 "361cf0687ec90990f9e5194eaaec92dd85200a917e29565f0b8d323edf550c58" => :yosemite
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

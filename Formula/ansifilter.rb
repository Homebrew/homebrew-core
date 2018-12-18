class Ansifilter < Formula
  desc "Strip or convert ANSI codes into HTML, (La)Tex, RTF, or BBCode"
  homepage "http://www.andre-simon.de/doku/ansifilter/ansifilter.html"
  url "http://www.andre-simon.de/zip/ansifilter-2.13.tar.bz2"
  sha256 "4022e6d763512cbbadc47264266c8796ee654ebd2f43daca4599d1f0281812c0"

  bottle do
    cellar :any_skip_relocation
    sha256 "54ac35d7070d268ddccfb365b02df23488642309bbf2f28bde95b79d8000915d" => :mojave
    sha256 "bc8b44b251714842c9f4b338f8ba129f3834ecf24b85247278e54e03033bbc69" => :high_sierra
    sha256 "66e69a7a4fe7190d7975fe414a43423bdd271dcf991017f3ce7e1f2f44b19590" => :sierra
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

class Ansifilter < Formula
  desc "Strip or convert ANSI codes into HTML, (La)Tex, RTF, or BBCode"
  homepage "http://www.andre-simon.de/doku/ansifilter/ansifilter.html"
  url "http://www.andre-simon.de/zip/ansifilter-2.13.tar.bz2"
  sha256 "4022e6d763512cbbadc47264266c8796ee654ebd2f43daca4599d1f0281812c0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a36f0458213473bc454fc5874b813a7f8d6d16f4bc06184641b9564e89b67f11" => :mojave
    sha256 "cc48b3139a95610a18173aff45235592fa0a8c1ef8a46a5b82a9bb225c37669c" => :high_sierra
    sha256 "8c8b40f0b954c12ab7fe0aa52abbb103b9b3e0b7be1132658bf1a370e3133daa" => :sierra
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

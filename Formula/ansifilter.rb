class Ansifilter < Formula
  desc "Strip or convert ANSI codes into HTML, (La)Tex, RTF, or BBCode"
  homepage "http://www.andre-simon.de/doku/ansifilter/ansifilter.html"
  url "http://www.andre-simon.de/zip/ansifilter-2.11.tar.bz2"
  sha256 "51e79ea56ba0e5a6cd564bd66e050f366be0e61c71a2b5800a3a213f8b39a9ca"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ec35f9e35cfc115ca9e58e15adba1322aaedacafaa6f397cc448c7b41138c80" => :mojave
    sha256 "690565aafd52e57f6118ef797c2de21c07414fd45779d410755431977ee70ea2" => :high_sierra
    sha256 "780259cbb6f47c914e40a334d15e4e55e3cecc45e76b737e23225c9c18975dce" => :sierra
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

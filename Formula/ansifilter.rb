class Ansifilter < Formula
  desc "Strip or convert ANSI codes into HTML, (La)Tex, RTF, or BBCode"
  homepage "http://www.andre-simon.de/doku/ansifilter/ansifilter.html"
  url "http://www.andre-simon.de/zip/ansifilter-2.3.tar.bz2"
  sha256 "26d5ccd21a05e66a1cf836efd24eaf088243d14c3bf322a26cf635a3dd6a5e48"

  bottle do
    cellar :any_skip_relocation
    sha256 "64c715cdb2d614d51d2d5d60c66048561da16cce65c2c9cda8d93b5179f045ec" => :sierra
    sha256 "dfe5377944141fc36f978a71e9e87bc031f1191be294bb26bc0c6c59046e26b8" => :el_capitan
    sha256 "73e4a7f4459c85e355a4e886be308f02eb1eb76f647c629f3707a96d3d93eebd" => :yosemite
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

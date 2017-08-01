class Ansifilter < Formula
  desc "Strip or convert ANSI codes into HTML, (La)Tex, RTF, or BBCode"
  homepage "http://www.andre-simon.de/doku/ansifilter/ansifilter.html"
  url "http://www.andre-simon.de/zip/ansifilter-2.6.tar.bz2"
  sha256 "4e3abd8c18197db85575c38418dbc8ee424d0caa0681589e5296fc8e72251175"

  bottle do
    cellar :any_skip_relocation
    sha256 "e3a5059c7b2ab37d14a31c56f0e1915d74be4a99c457152e2da34b447b239f17" => :sierra
    sha256 "b4c6798093521571f4cf5531d11a1058c0d3c58fc46fcef52bca51b3e2d91824" => :el_capitan
    sha256 "4035c693e04d159a0fab8022ea18bd789e65c5afef1f181c793b5c4a923f4c73" => :yosemite
  end

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    path = testpath/"ansi.txt"
    path.write "f\x1b[31moo\n"

    assert_equal "foo", shell_output("#{bin}/ansifilter #{path}").strip
  end
end

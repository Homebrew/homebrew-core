class Ansifilter < Formula
  desc "Strip or convert ANSI codes into HTML, (La)Tex, RTF, or BBCode"
  homepage "http://www.andre-simon.de/doku/ansifilter/ansifilter.html"
  url "http://www.andre-simon.de/zip/ansifilter-2.10.tar.bz2"
  sha256 "23d2cf439d4ed4fbec8050b2826d61c244694ce06aaf8ca7d0ec1016afebee3f"

  bottle do
    cellar :any_skip_relocation
    sha256 "a59769c66d17d7a219579cdfdabc0223c24cba81eeafaaafbecafc6e2717432c" => :high_sierra
    sha256 "69bac89db4a580436e09b4ed30815213eb758a00aba7a9e31f3807a69ab52ba1" => :sierra
    sha256 "f58852d9f7a99b20196236c5c52c17a4c802fbb5faf4c3484efc2e70137e2d74" => :el_capitan
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

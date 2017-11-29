class Ansifilter < Formula
  desc "Strip or convert ANSI codes into HTML, (La)Tex, RTF, or BBCode"
  homepage "http://www.andre-simon.de/doku/ansifilter/ansifilter.html"
  url "http://www.andre-simon.de/zip/ansifilter-2.9.tar.bz2"
  sha256 "f9c4c0d8a4532b89ee16ff5ac51eee46dc581fb4cc50d51a97dddd15385abc3a"

  bottle do
    cellar :any_skip_relocation
    sha256 "e629bc046bb6397c710ad9fb562b65784783f2169d98a20dab1c2d6025f71b64" => :high_sierra
    sha256 "24ec698255374e31b8aae4baeff95c234803f4d964e87c3b93753fd48ee007e4" => :sierra
    sha256 "e1152dc33df49dd85ddd0aec76d2ae63f2c60756e7c8310cdbe140c2e7506937" => :el_capitan
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

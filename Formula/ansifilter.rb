class Ansifilter < Formula
  desc "Strip or convert ANSI codes into HTML, (La)Tex, RTF, or BBCode"
  homepage "http://www.andre-simon.de/doku/ansifilter/ansifilter.html"
  url "http://www.andre-simon.de/zip/ansifilter-2.8.1.tar.bz2"
  sha256 "65556f76c234e709e9c3d326042e88a769ebf456c2fbbc5e32ffb247214fc6c6"

  bottle do
    cellar :any_skip_relocation
    sha256 "a05109993c3f9385e7fe021317ef2c9300a2e9f827f346162a0425e3ec478516" => :sierra
    sha256 "cde309f398ea0e0e3e0c0f3457f7c399716b025e7e8f3c3ff32304f925295282" => :el_capitan
    sha256 "6218b58e6e15bf1eda8a5e2d2141721b7f899e2478f9a51d5a19c6a79b25176d" => :yosemite
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

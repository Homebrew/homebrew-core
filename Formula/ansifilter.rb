class Ansifilter < Formula
  desc "Strip or convert ANSI codes into HTML, (La)Tex, RTF, or BBCode"
  homepage "http://www.andre-simon.de/doku/ansifilter/ansifilter.html"
  url "http://www.andre-simon.de/zip/ansifilter-2.7.tar.bz2"
  sha256 "6e844a21186a2011601aa87b37863fd946572bd86bbb145842ffa54c55bb4ecd"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c6da479861bc736eaa24600be3d1be05718adfe4772771c049758dd9ba0f7b9" => :sierra
    sha256 "2b33b3a0308b316b7c0854773b0a0834a257f04e462eb501382eb25f3061bf8d" => :el_capitan
    sha256 "281526691164a478642202429af22c2b4c095526c5c17b2ad226494e4f506bf2" => :yosemite
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

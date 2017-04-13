class Ansifilter < Formula
  desc "Strip or convert ANSI codes into HTML, (La)Tex, RTF, or BBCode"
  homepage "http://www.andre-simon.de/doku/ansifilter/ansifilter.html"
  url "http://www.andre-simon.de/zip/ansifilter-2.4.tar.bz2"
  sha256 "c57cb878afa7191c7b7db3c086a344b4234df814aed632596619a4bda5941d48"

  bottle do
    cellar :any_skip_relocation
    sha256 "78ed9ef868947cfeae4d0f66b8e350c8efa924a591fe5d91920bf9e0661aeaf7" => :sierra
    sha256 "4261a8911d6d9857deade640e49dc74925fc80c30ae8d2e1447739076aa6a667" => :el_capitan
    sha256 "a8b14c4bc4ad5a6ebbcf8d1c7ee52d2c1f24951483b84022d4b8009e16df7182" => :yosemite
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

class Ps2eps < Formula
  desc "Convert PostScript to EPS files"
  homepage "https://www.tm.uka.de/~bless/ps2eps"
  url "https://www.tm.uka.de/~bless/ps2eps-1.68.tar.gz"
  sha256 "b08f12eed88965d1891261fb70e87c7e3a3f3172ebc31bdb7994a7ce854dd925"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "77353530f3a9a9f4b3776087336b18f76186373f97efeb56f0d2d55e726198f4" => :catalina
    sha256 "2d77404809045015e8de81dc40e5ac200fcdeab46cb04df65d6e3e50d1b9490e" => :mojave
    sha256 "d7f3f76cc2ef7b221c099811059dc7901feeb86eea6aad5fffe4dfc50448b80a" => :high_sierra
    sha256 "eb9e2a32e389d61270e196d45bccf6ce78720ee5104487d16e4e906ec888c8d4" => :sierra
  end

  depends_on "ghostscript"

  def install
    system ENV.cc, "src/C/bbox.c", "-o", "bbox"
    bin.install "bbox"
    (libexec/"bin").install "bin/ps2eps"
    (bin/"ps2eps").write <<~EOS
      #!/bin/sh
      perl -S #{libexec}/bin/ps2eps \"$@\"
    EOS
    share.install "doc/man"
    doc.install "doc/pdf", "doc/html"
  end

  test do
    cp test_fixtures("test.ps"), testpath/"test.ps"
    system bin/"ps2eps", testpath/"test.ps"
    assert_predicate testpath/"test.eps", :exist?
  end
end

class Ps2eps < Formula
  desc "Convert PostScript to EPS files"
  homepage "https://www.tm.uka.de/~bless/ps2eps"
  url "https://www.tm.uka.de/~bless/ps2eps-1.68.tar.gz"
  sha256 "b08f12eed88965d1891261fb70e87c7e3a3f3172ebc31bdb7994a7ce854dd925"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "62472599f3fcc54199d9ce91a531c8f4b214f203c3ffca3e11c9bdc695a13f67" => :mojave
    sha256 "d4d32e9dc8797d307a015aa1212b551238f540be6fc14f5c08c97a34ab37607f" => :high_sierra
    sha256 "33db202a803be71441bf48c5588262ed4cf7d3cb41121f91d881e1a304dac6df" => :sierra
    sha256 "c4196890ab40c69d270da676c9039ae80b58c9241fb3d11211903c126a42443e" => :el_capitan
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

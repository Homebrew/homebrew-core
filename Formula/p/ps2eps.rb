class Ps2eps < Formula
  desc "Convert PostScript to EPS files"
  homepage "https://github.com/roland-bless/ps2eps"
  url "https://github.com/roland-bless/ps2eps/archive/refs/tags/v1.71.tar.gz"
  sha256 "5020371b18a661ed40fa5567420bde562f15e47827616792f2e4389af61d24c6"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3de6a32878ee0dfd184245f74d3ad706b669384c6115051b0efc62220889e346"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbba0b0707b327315648cca252c79a5d816966c39970a3e6dcca59a8f3c97d7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be72fe232327a965fc95ebf660558104cc71659305026c1c06b1788e2f912fb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cbec2b24c55373d40dab088e2fd38a4dd5710466a357cbf8809a6bf41a993cb"
    sha256 cellar: :any,                 arm64_linux:   "150ba6d03a0890370ae4cc32442e14f53fafb0b4c139f01750f1df2af8aa5747"
    sha256 cellar: :any,                 x86_64_linux:  "a529c083f0ca26c98810a79b961245e46e2dacee8d74304a91dd9a17a6fdb711"
  end

  depends_on "ghostscript"

  def install
    system ENV.cc, "src/C/bbox.c", "-o", "bbox"
    bin.install "bbox"
    (libexec/"bin").install "src/perl/ps2eps"
    (bin/"ps2eps").write <<~SH
      #!/bin/sh
      perl -S #{libexec}/bin/ps2eps "$@"
    SH
    man1.install Dir["doc/*.1"]
    doc.install Dir["doc/*.pdf", "doc/*.html"]
  end

  test do
    cp test_fixtures("test.ps"), testpath/"test.ps"
    system bin/"ps2eps", testpath/"test.ps"
    assert_path_exists testpath/"test.eps"
  end
end

class Djvu2pdf < Formula
  desc "Small tool to convert Djvu files to PDF files"
  homepage "https://0x2a.at/site/projects/djvu2pdf/"
  url "https://0x2a.at/site/projects/djvu2pdf/djvu2pdf-0.9.2.tar.gz"
  sha256 "afe86237bf4412934d828dfb5d20fe9b584d584ef65b012a893ec853c1e84a6c"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?djvu2pdf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "9fdbe69a5415de2630d2a2934f513f985db8d4917b5451ef0241fd125e1096fc"
  end

  depends_on "djvulibre"
  depends_on "ghostscript"

  def install
    bin.install "djvu2pdf"
    man1.install "djvu2pdf.1.gz"
  end

  test do
    system bin/"djvu2pdf", "-h"
  end
end

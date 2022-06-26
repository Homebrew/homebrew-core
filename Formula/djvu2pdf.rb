class Djvu2pdf < Formula
  desc "Small tool to convert Djvu files to PDF files"
  homepage "https://0x2a.at/site/projects/djvu2pdf/"
  url "https://0x2a.at/site/projects/djvu2pdf/djvu2pdf-0.9.2.tar.gz"
  sha256 "afe86237bf4412934d828dfb5d20fe9b584d584ef65b012a893ec853c1e84a6c"

  livecheck do
    url :homepage
    regex(/href=.*?djvu2pdf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "712580b5fb3dc550722146cdce9ce17c9928565a29433bd0697cb231691e566f"
  end

  depends_on "djvulibre"
  depends_on "ghostscript"

  def install
    bin.install "djvu2pdf"
    man1.install "djvu2pdf.1.gz"
  end

  test do
    system "#{bin}/djvu2pdf", "-h"
  end
end

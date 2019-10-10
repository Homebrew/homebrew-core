class Pdfcrack < Formula
  desc "PDF files password cracker"
  homepage "https://pdfcrack.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pdfcrack/pdfcrack/pdfcrack-0.18/pdfcrack-0.18.tar.gz"
  sha256 "8223aec52a2ae36f9a10a731513461458874f1fd8d803e4a04910d9dbf1cba0c"

  bottle do
    cellar :any_skip_relocation
    sha256 "a70ee2e224ba6650265a93fa0cdef209baf3721f76c4f00a0c8edf497426d588" => :catalina
    sha256 "02521002ff10a9cd937464143ca29065288c3a3e6f1f27c0ef4e663af5ce8a73" => :mojave
    sha256 "516cf147a20751bf6c76871fcb471fbab770949b18e3f417bf97ba3a4ce44207" => :high_sierra
    sha256 "0eab853d75f86a085fcf3f93681d795dab857012701fe85ddbe598b9e12dbfbd" => :sierra
  end

  def install
    system "make", "all"
    bin.install "pdfcrack"
  end

  test do
    system "#{bin}/pdfcrack", "--version"
  end
end

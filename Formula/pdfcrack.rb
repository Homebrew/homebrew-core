class Pdfcrack < Formula
  desc "PDF files password cracker"
  homepage "https://pdfcrack.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pdfcrack/pdfcrack/pdfcrack-0.18/pdfcrack-0.18.tar.gz"
  sha256 "8223aec52a2ae36f9a10a731513461458874f1fd8d803e4a04910d9dbf1cba0c"

  bottle do
    cellar :any_skip_relocation
    sha256 "a90c034da71cc7aab72ea89c9693c73294258d33eff99449494a47824f7f74cd" => :mojave
    sha256 "5b04e434a4a7f19cda66fc9fd85d06af7911c6a8541da9b256d0286b2e4a3ef8" => :high_sierra
    sha256 "e62512a0ab06aef14644bfe289e9e22ec579c17f64767346ccd4562a389211ca" => :sierra
  end

  def install
    system "make", "all"
    bin.install "pdfcrack"
  end

  test do
    system "#{bin}/pdfcrack", "--version"
  end
end

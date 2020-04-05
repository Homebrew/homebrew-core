class Pdftohtml < Formula
  desc "PDF to HTML converter (based on xpdf)"
  homepage "https://pdftohtml.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pdftohtml/Experimental%20Versions/pdftohtml%200.40/pdftohtml-0.40a.tar.gz"
  sha256 "277ec1c75231b0073a458b1bfa2f98b7a115f5565e53494822ec7f0bcd8d4655"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "d8a6e5bb1d84ee766898543d77307b4a9a6e6f826ebe9cc48ce6db8bb24c8923" => :catalina
    sha256 "c49245634c48c7c24501cfb848a98e4b6a281ff0cf89235bb7a7ce09619e66ad" => :mojave
    sha256 "200be428031e013f58b792b092b56e74743d6362d747b0c883bb95269d7a5e72" => :high_sierra
  end

  conflicts_with "pdf2image", "poppler", "xpdf",
    :because => "poppler, pdftohtml, pdf2image, and xpdf install conflicting executables"

  def install
    system "make"
    bin.install "src/pdftohtml"
  end
end

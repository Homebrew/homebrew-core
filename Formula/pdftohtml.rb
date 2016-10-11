class Pdftohtml < Formula
  desc "PDF to HTML converter (based on xpdf)"
  homepage "http://pdftohtml.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/pdftohtml/Experimental%20Versions/pdftohtml%200.40/pdftohtml-0.40a.tar.gz"
  sha256 "277ec1c75231b0073a458b1bfa2f98b7a115f5565e53494822ec7f0bcd8d4655"

  bottle do
    cellar :any_skip_relocation
    sha256 "e896f26ac73f3a272aa17ee1815f3b173b94fa59680a8db3c0a814865da86afc" => :sierra
    sha256 "622c66d77a35af1bbf94ee35ecba358d8868e187f664c68da729da0d3bead266" => :el_capitan
    sha256 "9d222cce9a02a311248083aead8e4b55e9ac98ce98035a13d021b48d05eb5119" => :yosemite
    sha256 "9dc35272d91c790627d21a93ca058c038ab660b9a6e619f35758a10c02e7dea9" => :mavericks
  end

  conflicts_with "poppler", :because => "both install `pdftohtml` binaries"

  def install
    system "make"
    bin.install "src/pdftohtml"
  end
end

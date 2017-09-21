class Pdftohtml < Formula
  desc "PDF to HTML converter (based on xpdf)"
  homepage "https://pdftohtml.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pdftohtml/Experimental%20Versions/pdftohtml%200.40/pdftohtml-0.40a.tar.gz"
  sha256 "277ec1c75231b0073a458b1bfa2f98b7a115f5565e53494822ec7f0bcd8d4655"

  bottle do
    rebuild 1
    sha256 "22264623cdbc31cb0d24f1a7fa5afa22a7fbea71f420877ab921611ea9b5c983" => :sierra
    sha256 "8ecdcb1b267387509e8efc6637f119c782a70c6d4326201e0e76f06eb29dbcc1" => :el_capitan
  end

  conflicts_with "poppler", :because => "both install `pdftohtml` binaries"

  def install
    system "make"
    bin.install "src/pdftohtml"
  end
end

class Docx2txt < Formula
  desc "Converts Microsoft Office docx documents to equivalent text documents"
  homepage "http://docx2txt.sourceforge.net/"
  url "https://downloads.sourceforge.net/docx2txt/docx2txt-1.4.tgz"
  sha256 "b297752910a404c1435e703d5aedb4571222bd759fa316c86ad8c8bbe58c6d1b"

  resource "sample_doc" do
    url "http://calibre-ebook.com/downloads/demos/demo.docx", :using => :nounzip
    sha256 "269329fc7ae54b3f289b3ac52efde387edc2e566ef9a48d637e841022c7e0eab"
  end

  def install
    system "make", "install", "CONFIGDIR=#{etc}", "BINDIR=#{bin}"
  end

  test do
    testpath.install resource("sample_doc")
    system "#{bin}/docx2txt.sh", "#{testpath}/demo.docx"
  end
end

class Docx2txt < Formula
  desc "Converts Microsoft Office docx documents to equivalent text documents"
  homepage "https://docx2txt.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/docx2txt/docx2txt/v1.4/docx2txt-1.4.tgz"
  sha256 "b297752910a404c1435e703d5aedb4571222bd759fa316c86ad8c8bbe58c6d1b"
  license "GPL-3.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "8149e29356c8f77acf1aa2f979db01443f112a0b7298910a2b1e386b3da1c8cf"
  end

  resource "sample_doc" do
    url "https://calibre-ebook.com/downloads/demos/demo.docx"
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

class Docx2txt < Formula
  desc "Converts Microsoft Office docx documents to equivalent text documents"
  homepage "https://docx2txt.sourceforge.io/"
  url "https://downloads.sourceforge.net/docx2txt/docx2txt-1.4.tgz"
  sha256 "b297752910a404c1435e703d5aedb4571222bd759fa316c86ad8c8bbe58c6d1b"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7540b467b577f25c72f86a0d23581f6eb613bcd6482de7ea5b01405cf2f6358" => :mojave
    sha256 "fb8efe02d448cdbda874a9fe06b11ebd0ace98b88d4e1792aab632fd0371e178" => :high_sierra
    sha256 "001618f763145ba1027169c8b7f687cd1ceacd09bc5b4c7e64e61deaa2a1ec4c" => :sierra
    sha256 "c3a67138c91e968e6c2a6ff1033bca0fe8527ebdcaaa208194c073b4f75dd453" => :el_capitan
    sha256 "78154a4b95613538a9d508c521d74d0bc6b398b005de4468b4cb4e62c3208b8e" => :yosemite
    sha256 "2d9f0f37b4c6c5a37f22a4b0e7cdc6d440e842d2d3e7df433ccebf1b03cf80cd" => :mavericks
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

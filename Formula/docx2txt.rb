class Docx2txt < Formula
  desc "Converts Microsoft Office docx documents to equivalent text documents"
  homepage "https://docx2txt.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/docx2txt/docx2txt/v1.4/docx2txt-1.4.tgz"
  sha256 "b297752910a404c1435e703d5aedb4571222bd759fa316c86ad8c8bbe58c6d1b"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2d6e1722f2db28c4cd573b95de24ca37c4166ef25d7769b766d88e5f73140bf3"
    sha256 cellar: :any_skip_relocation, big_sur:       "3d8f83b8f721e0e232b81a6a35345634ee180065682cb542d10e99894a9e69b0"
    sha256 cellar: :any_skip_relocation, catalina:      "5fd07512b1396d0cda3b025352da258523470374318723c5d0bdf41a7d174e8c"
    sha256 cellar: :any_skip_relocation, mojave:        "b7540b467b577f25c72f86a0d23581f6eb613bcd6482de7ea5b01405cf2f6358"
    sha256 cellar: :any_skip_relocation, high_sierra:   "fb8efe02d448cdbda874a9fe06b11ebd0ace98b88d4e1792aab632fd0371e178"
    sha256 cellar: :any_skip_relocation, sierra:        "001618f763145ba1027169c8b7f687cd1ceacd09bc5b4c7e64e61deaa2a1ec4c"
    sha256 cellar: :any_skip_relocation, el_capitan:    "c3a67138c91e968e6c2a6ff1033bca0fe8527ebdcaaa208194c073b4f75dd453"
    sha256 cellar: :any_skip_relocation, yosemite:      "78154a4b95613538a9d508c521d74d0bc6b398b005de4468b4cb4e62c3208b8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8149e29356c8f77acf1aa2f979db01443f112a0b7298910a2b1e386b3da1c8cf"
    sha256 cellar: :any_skip_relocation, all:           "8149e29356c8f77acf1aa2f979db01443f112a0b7298910a2b1e386b3da1c8cf"
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

class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.13.1.tar.gz"
  sha256 "c8725d78e43b7d6a04465e8a156bc4c6a78121f291aac74e0b0a10286ef95544"
  revision 1

  bottle do
    cellar :any
    sha256 "229953eff061f63b1051478c487c0cba54fc2e4eb65ceec3827debe8bf173026" => :catalina
    sha256 "3eb9a755e677baff669f6c70312124db65f110c612332880a5b9572e0e8e60a5" => :mojave
    sha256 "c011183f12bd935484379638b7ac93ac5142567d15711a2b13d8391b6224a035" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "poppler"

  def install
    ENV.cxx11

    cd "pdftoipe" do
      system "make"
      bin.install "pdftoipe"
      man1.install "pdftoipe.1"
    end
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    system bin/"pdftoipe", "test.pdf"
    assert_match "<ipestyle>", File.read("test.ipe")
  end
end

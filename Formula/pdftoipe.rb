class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.8.1.tar.gz"
  sha256 "a6174aae72f93b56c6652c2c27d5203e0f867e11a5e1c7d89c4aa3b4bcb67eb3"

  bottle do
    cellar :any
    sha256 "07ed1775adadc3b241bb7994fece568815c173960cf5fa613f1e6aa871cf5ffe" => :mojave
    sha256 "217fbc3e5539f5e7507ecdcf7b5def07477136903e6e9ce073c4d692ee8618b9" => :high_sierra
    sha256 "e9179da87748c561bf55a6866eb88301c4b1f53baae4d6137fdb9b5f78c01186" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "poppler"

  needs :cxx11

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
    assert_match "Homebrew test.</text>", File.read("test.ipe")
  end
end

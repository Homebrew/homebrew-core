class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/refs/tags/v7.3.1.2.tar.gz"
  sha256 "edb8f098c32f0ae626ac20ebdd0f2114fc1d1cc4d730a7abb648cfe9c131e40d"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "edf83419cfbde36e51c327b00c770607d14a6f649873dd3eeb2326abcfe87493"
    sha256 cellar: :any, arm64_tahoe:       "a6fd642d05f852ee573833a9efef3eaf7f1a3329d316fab24114c6cc471bbb08"
    sha256 cellar: :any, arm64_sequoia:     "141130711b964a9de82d9094dad77f1a71b6c877bc28e53b9e69f1cf6086d6de"
    sha256 cellar: :any, arm64_linux:       "52a4dbcbd90f1b189cd95e1d5517240bd883ebdaeb0b832d8d5d63c015ecddba"
    sha256 cellar: :any, x86_64_linux:      "387899dcd078a86f45e7bd05bd597d8c7196213bcf5a088d9ff80896cbc16bdb"
  end

  depends_on "pkgconf" => :build
  depends_on "poppler"

  def install
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

class PdfTocgen < Formula
  include Language::Python::Virtualenv

  desc "CLI toolset to generate table of contents for PDF files automatically"
  homepage "https://krasjet.com/voice/pdf.tocgen/"
  url "https://files.pythonhosted.org/packages/77/44/e6dafea2c491e84425ed725b69b689e58703609b1d70e7b7f49f28cf5df7/pdf_tocgen-1.3.4.tar.gz"
  sha256 "090758832614727eaf1fd0ba0075d5a10eb8f268d1d534fabd7131170a8ac79e"
  license "GPL-3.0-or-later"
  head "https://github.com/Krasjet/pdf.tocgen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4178fa0d5eae318d730fde9f7114d19ed07d9d819c8c5412de7099d550d5595a"
  end

  depends_on "pymupdf"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "pymupdf"

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    resource "pdf" do
      url "https://raw.githubusercontent.com/Krasjet/pdf.tocgen/refs/heads/master/spec/files/level2.pdf"
      sha256 "021e4d025341d31babee19e6b75afb26f167923db42d1d038610edb328b82da2"
    end

    resource "toc" do
      url "https://raw.githubusercontent.com/Krasjet/pdf.tocgen/refs/heads/master/spec/files/level2.toc"
      sha256 "b32649c6c86738542720fcfb9eaa3f1dff0b50b27865ee9c1558271010508bf1"
    end

    testpath.install resource("pdf")
    testpath.install resource("toc")

    # Test recipe creation with pdfxmeta
    system "#{bin}/pdfxmeta -a 1 -p 1 level2.pdf Section | grep -v 'greedy' >> recipe.toml"
    system "#{bin}/pdfxmeta -a 2 -p 2 level2.pdf Subsection | grep -v 'greedy' >> recipe.toml"
    assert_match "level = 1\nfont.name = \"CMBX12\"", File.read(testpath/"recipe.toml")

    # Test toc generation with pdftocgen
    system "#{bin}/pdftocgen level2.pdf -r recipe.toml > generated.toc"
    assert_equal File.read(testpath/"level2.toc"), File.read(testpath/"generated.toc")
  end
end

class Img2pdf < Formula
  include Language::Python::Virtualenv

  desc "Convert images to PDF via direct JPEG inclusion"
  homepage "https://gitlab.mister-muffin.de/josch/img2pdf"
  url "https://files.pythonhosted.org/packages/8e/97/ca44c467131b93fda82d2a2f21b738c8bcf63b5259e3b8250e928b8dd52a/img2pdf-0.6.3.tar.gz"
  sha256 "219518020f5bd242bdc46493941ea3f756f664c2e86f2454721e74353f58cd95"
  license "LGPL-3.0-or-later"
  revision 1
  compatibility_version 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "4a421c302d106b5ce96c46bfaaa6745f9f1d871b970f30a827ce5d2fedbca3e4"
    sha256 cellar: :any, arm64_tahoe:       "d0e78d91b191baf86f8d13f956baea5ffd647b9ee6b7b493d7bf8fe3adc45497"
    sha256 cellar: :any, arm64_sequoia:     "14f04c5d20be7f1056201609ce6c7b9de596569b3085d08062735bfbcc74a78b"
    sha256 cellar: :any, arm64_linux:       "8fe980098f4d9ee4b6401cdb32ad925710db324ea760501ce3d1b030f914869d"
    sha256 cellar: :any, x86_64_linux:      "550b86d43403f8d6ba3f806f48031fb29d8d71747a9bb11d401ea45510bfabbd"
  end

  depends_on "pillow" => :no_linkage
  depends_on "python@3.15"
  depends_on "qpdf"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: "pillow"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/23/ad/28ecd7cb894d172f3c9c80a075eeeb2017ac62e3632cee05a5f9493547eb/lxml-6.1.3.tar.gz"
    sha256 "45222d94ddd511536f3b2f7d9deae3b2339b4ce0f075f1ca25703b07cad9dd21"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/32/80/0fb229f1d4772f102af425975b302c9de1b177b3e191ed7f7ffe24a02e98/pikepdf-10.16.0.tar.gz"
    sha256 "d9541429f079f7838f2856fea5c2ad165885693cdb36894e73d40d1b845d2e11"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"img2pdf", test_fixtures("test.png"), test_fixtures("test.jpg"),
                             test_fixtures("test.tiff"), "--pagesize", "A4", "-o", "test.pdf"
    assert_path_exists testpath/"test.pdf"
  end
end

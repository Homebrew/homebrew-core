class Img2pdf < Formula
  include Language::Python::Virtualenv

  desc "Convert images to PDF via direct JPEG inclusion"
  homepage "https://gitlab.mister-muffin.de/josch/img2pdf"
  url "https://files.pythonhosted.org/packages/8e/97/ca44c467131b93fda82d2a2f21b738c8bcf63b5259e3b8250e928b8dd52a/img2pdf-0.6.3.tar.gz"
  sha256 "219518020f5bd242bdc46493941ea3f756f664c2e86f2454721e74353f58cd95"
  license "LGPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "93bad8464794c25df4501a2086684cd89c20dec0e29aa525fc79740589e178a2"
    sha256 cellar: :any,                 arm64_tahoe:       "db4bab2ef1957472035a4e64c0d00639a59d489d06e19391cb692e12ec68d0ef"
    sha256 cellar: :any,                 arm64_sequoia:     "b8d58b3f73159f1b9866d82bea652d72b5cc1617076927a905ce3452fbd712fe"
    sha256 cellar: :any,                 arm64_sonoma:      "fbc43113376bfa8a7573c40fc143dbabfe5bbada6ef0eb4aa0d3ce80a71a51b7"
    sha256 cellar: :any,                 sonoma:            "aadfcfd88e1cdf0f6c79c52428615d416144711df74d20b6584b76b5de54ecac"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f3e9f1a54e0899a5b11695fd5e583daee1761cdb5cbbd08655e7719a60222c6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "afe3e84cf63526c03c3a6aea5e3588661ff9cb434b8e47937764eb43bf3f954e"
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

class Httpie < Formula
  include Language::Python::Virtualenv

  desc "User-friendly cURL replacement (command-line HTTP client)"
  homepage "https://httpie.org/"
  url "https://files.pythonhosted.org/packages/d5/a4/ab61c1dbfdef33c7b7f5f7df0d79eb5cd55a106601a4acc17f983f320b4a/httpie-1.0.3.tar.gz"
  sha256 "6d1b6e21da7d3ec030ae95536d4032c1129bdaf9de4adc72c596b87e5f646e80"
  head "https://github.com/jakubroztocil/httpie.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "641b4d390468b8759f0b43a5f30074a680bbe61d71be201b7f7a48f7e497bd20" => :catalina
    sha256 "2436432e8ee1efe7f6c19c501af35aba453dabe3b9a9f88bed4e22a795bc6d1c" => :mojave
    sha256 "e50d67eb555607a235a14ee0c80e484c08295aed71fb82dad4ef9afc4af1c9b7" => :high_sierra
    sha256 "153ce88d4496d04fa1ba61641841b2c89254687af8c7e9aca7127b298e3ee0f1" => :sierra
  end

  depends_on "python"

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/7e/ae/26808275fc76bf2832deb10d3a3ed3107bc4de01b85dcccbe525f2cd6d1e/Pygments-2.4.2.tar.gz"
    sha256 "881c4c157e45f30af185c1ffe8d549d48ac9127433f2c380c24b84572ad66297"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/01/62/ddcf76d1d19885e8579acb1b1df26a852b03472c0e46d2b959a714c90608/requests-2.22.0.tar.gz"
    sha256 "11e007a8a2aa0323f5a921e9e6a2d7e4e67d9877e85773fba9ba6419025cbeb4"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/c5/67/5d0548226bcc34468e23a0333978f0e23d28d0b3f0c71a151aef9c3f7680/certifi-2019.6.16.tar.gz"
    sha256 "945e3ba63a0b9f577b1395204e13c3a231f9bc0223888be653286534e5873695"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/4c/13/2386233f7ee40aa8444b47f7463338f3cbdf00c316627558784e3f542f07/urllib3-1.25.3.tar.gz"
    sha256 "dbe59173209418ae49d485b87d1681aefa36252ee85884c31346debd19463232"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz"
    sha256 "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "PySocks" do
    url "https://files.pythonhosted.org/packages/15/ab/35824cfdee1aac662e3298275fa1e6cbedb52126d1785f8977959b769ccf/PySocks-1.7.0.tar.gz"
    sha256 "d9031ea45fdfacbe59a99273e9f0448ddb33c1580fe3831c1b09557c5718977c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    raw_url = "https://raw.githubusercontent.com/Homebrew/homebrew-core/master/Formula/httpie.rb"
    assert_match "PYTHONPATH", shell_output("#{bin}/http --ignore-stdin #{raw_url}")
  end
end

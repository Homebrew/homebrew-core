class Cookiecutter < Formula
  include Language::Python::Virtualenv

  desc "Utility that creates projects from templates"
  homepage "https://github.com/audreyr/cookiecutter"
  url "https://github.com/audreyr/cookiecutter/archive/1.5.0.tar.gz"
  sha256 "553d00dcbdb6eed252ff15b5622ed98b2a22ffa96fc1b49717b4fbea32378526"
  head "https://github.com/audreyr/cookiecutter.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "61ff84622d8d146d58fe5310641b4d5b8b9b53ff3f34440e937d4a929a11cc4d" => :sierra
    sha256 "2012fd7fc78145c93c364d26f77c0bce451e9bb7118612e71e310b3fa7fd221b" => :el_capitan
    sha256 "4b18b3aaec7ddab6670513b828cbc870544927bd09a8a69c01ef03ec92f5029c" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/54/db/76459c4dd3561bbe682619a5c576ff30c42e37c2e01900ed30a501957150/arrow-0.10.0.tar.gz"
    sha256 "805906f09445afc1f0fc80187db8fe07670e3b25cdafa09b8d8ac264a8c0c722"
  end

  resource "binaryornot" do
    url "https://files.pythonhosted.org/packages/52/69/9ca055b887ccc841fa2d0265aa2599c9d63bc57d3d421dfcda874e0ad3ef/binaryornot-0.4.0.tar.gz"
    sha256 "ab0f387b28912ac9c300db843461359e2773da3b922ae378ab69b0d85b288ec8"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/7d/87/4e3a3f38b2f5c578ce44f8dc2aa053217de9f0b6d737739b0ddac38ed237/chardet-2.3.0.tar.gz"
    sha256 "e53e38b3a4afe6d1132de62b7400a4ac363452dc5dfcf8d88e8e0cce663c68aa"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/7a/00/c14926d8232b36b08218067bcd5853caefb4737cda3f0a47437151344792/click-6.6.tar.gz"
    sha256 "cc6a19da8ebff6e7074f731447ef7e112bd23adf3de5c597cf9989f2fd8defe9"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/00/2b/8d082ddfed935f3608cc61140df6dcbf0edea1bc3ab52fb6c29ae3e81e85/future-0.16.0.tar.gz"
    sha256 "e39ced1ab767b5936646cedba8bcce582398233d6a627067d4c6a454c90cfedb"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/f2/2f/0b98b06a345a761bec91a079ccae392d282690c2d8272e708f4d10829e22/Jinja2-2.8.tar.gz"
    sha256 "bc1ff2ff88dbfacefde4ddde471d1417d3b304e8df103a7a9437d47269201bf4"
  end

  resource "jinja2-time" do
    url "https://files.pythonhosted.org/packages/de/7c/ee2f2014a2a0616ad3328e58e7dac879251babdb4cb796d770b5d32c469f/jinja2-time-0.2.0.tar.gz"
    sha256 "d14eaa4d315e7688daa4969f616f226614350c48730bfa1692d2caebd8c90d40"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/c0/41/bae1254e0396c0cc8cf1751cb7d9afc90a602353695af5952530482c963f/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "poyo" do
    url "https://files.pythonhosted.org/packages/7a/93/3f5e0a792de7470ffe730bdb6a3dc311b8f9734aa65598ad3825bbf48edf/poyo-0.4.0.tar.gz"
    sha256 "8a95d95193eb0838117cc8847257bf17248ef6d157aaa55ea5c20509a87388b8"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/51/fc/39a3fbde6864942e8bb24c93663734b74e281b984d1b8c4f95d64b0c21f6/python-dateutil-2.6.0.tar.gz"
    sha256 "62a2f8df3d66f878373fd0072eacf4ee52194ba302e00082828e0d263b0418d2"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "whichcraft" do
    url "https://files.pythonhosted.org/packages/6b/73/c38063b84519a2597c0a57e472d28970d2f8ad991fde18612ff3708fda0c/whichcraft-0.4.0.tar.gz"
    sha256 "e756d2d9f157ab8516e7e9849c1808c57162b3689734a588c9a134e2178049a9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "git", "clone", "https://github.com/audreyr/cookiecutter-pypackage.git"
    system bin/"cookiecutter", "--no-input", "cookiecutter-pypackage"
    assert (testpath/"python_boilerplate").directory?
  end
end

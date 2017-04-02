class Cookiecutter < Formula
  include Language::Python::Virtualenv

  desc "Utility that creates projects from templates"
  homepage "https://github.com/audreyr/cookiecutter"
  url "https://github.com/audreyr/cookiecutter/archive/1.5.1.tar.gz"
  sha256 "eaf8c67c75335b899e58c608562536b4159284e8078cb59591505526aab7bbea"
  head "https://github.com/audreyr/cookiecutter.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9c4c18b9f4f389903998af689dba4ba58a60613da60fff825edc3dfcc7c80cf5" => :sierra
    sha256 "5497ae2200f26c0474079aa17aea4a36ef8f4dbccbe1d76c5a99d1b31fc731d1" => :el_capitan
    sha256 "f2aca9bcfdca4486607257193c112dd3ec5d0ebf5c281b5791ad4b40f6e447c9" => :yosemite
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
    url "https://files.pythonhosted.org/packages/95/d9/c3336b6b5711c3ab9d1d3a80f1a3e2afeb9d8c02a7166462f6cc96570897/click-6.7.tar.gz"
    sha256 "f15516df478d5a56180fbf80e68f206010e6d160fc39fa508b65e035fd75130b"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/00/2b/8d082ddfed935f3608cc61140df6dcbf0edea1bc3ab52fb6c29ae3e81e85/future-0.16.0.tar.gz"
    sha256 "e39ced1ab767b5936646cedba8bcce582398233d6a627067d4c6a454c90cfedb"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/71/59/d7423bd5e7ddaf3a1ce299ab4490e9044e8dfd195420fc83a24de9e60726/Jinja2-2.9.5.tar.gz"
    sha256 "702a24d992f856fa8d5a7a36db6128198d0c21e1da34448ca236c42e92384825"
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

class Cookiecutter < Formula
  desc "Utility that creates projects from templates"
  homepage "https://github.com/audreyr/cookiecutter"
  url "https://pypi.python.org/packages/source/c/cookiecutter/cookiecutter-1.4.0.tar.gz"
  sha256 "0b4d52480f9acfc5d9435abffe9eae053f509ed9388470fc51e961345afc6bed"
  head "https://github.com/audreyr/cookiecutter.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1a1ef5ec1914308dd8bfe67a317b1b474c9471ada86c68d181757fcc66c92364" => :sierra
    sha256 "f890850e9a9255787011d04a2652260f012ff71eeac42f19b0d530769bf7b3c6" => :el_capitan
    sha256 "2c42704bdadc04a98dbf4eebe995255a7a084aab11365843b9322f539c4e4ca8" => :yosemite
    sha256 "4e9e88675e9c9739a5927d93c2a16f88034eaed8b852e6edb5fe683d2c858c59" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "arrow" do
    url "https://pypi.python.org/packages/source/a/arrow/arrow-0.7.0.tar.gz"
    sha256 "2a5333007af117a05a488b69c9ae15c26c23eefa25f084992b025d387e03a17b"
  end

  resource "binaryornot" do
    url "https://pypi.python.org/packages/source/b/binaryornot/binaryornot-0.4.0.tar.gz"
    sha256 "ab0f387b28912ac9c300db843461359e2773da3b922ae378ab69b0d85b288ec8"
  end

  resource "chardet" do
    url "https://pypi.python.org/packages/source/c/chardet/chardet-2.3.0.tar.gz"
    sha256 "e53e38b3a4afe6d1132de62b7400a4ac363452dc5dfcf8d88e8e0cce663c68aa"
  end

  resource "click" do
    url "https://pypi.python.org/packages/source/c/click/click-6.6.tar.gz"
    sha256 "cc6a19da8ebff6e7074f731447ef7e112bd23adf3de5c597cf9989f2fd8defe9"
  end

  resource "future" do
    url "https://pypi.python.org/packages/source/f/future/future-0.15.2.tar.gz"
    sha256 "3d3b193f20ca62ba7d8782589922878820d0a023b885882deec830adbf639b97"
  end

  resource "Jinja2" do
    url "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.8.tar.gz"
    sha256 "bc1ff2ff88dbfacefde4ddde471d1417d3b304e8df103a7a9437d47269201bf4"
  end

  resource "jinja2-time" do
    url "https://pypi.python.org/packages/de/7c/ee2f2014a2a0616ad3328e58e7dac879251babdb4cb796d770b5d32c469f/jinja2-time-0.2.0.tar.gz"
    sha256 "d14eaa4d315e7688daa4969f616f226614350c48730bfa1692d2caebd8c90d40"
  end

  resource "MarkupSafe" do
    url "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "poyo" do
    url "https://pypi.python.org/packages/7a/93/3f5e0a792de7470ffe730bdb6a3dc311b8f9734aa65598ad3825bbf48edf/poyo-0.4.0.tar.gz"
    sha256 "8a95d95193eb0838117cc8847257bf17248ef6d157aaa55ea5c20509a87388b8"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/3e/f5/aad82824b369332a676a90a8c0d1e608b17e740bbb6aeeebca726f17b902/python-dateutil-2.5.3.tar.gz"
    sha256 "1408fdb07c6a1fa9997567ce3fcee6a337b39a503d80699e0f213de4aa4b32ed"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "whichcraft" do
    url "https://pypi.python.org/packages/6b/73/c38063b84519a2597c0a57e472d28970d2f8ad991fde18612ff3708fda0c/whichcraft-0.4.0.tar.gz"
    sha256 "e756d2d9f157ab8516e7e9849c1808c57162b3689734a588c9a134e2178049a9"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage { system "python", *Language::Python.setup_install_args(libexec/"vendor") }
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "git", "clone", "https://github.com/audreyr/cookiecutter-pypackage.git"
    system bin/"cookiecutter", "--no-input", "cookiecutter-pypackage"
    assert (testpath/"python_boilerplate").directory?
  end
end

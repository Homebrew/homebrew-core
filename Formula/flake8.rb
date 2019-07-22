class Flake8 < Formula
  include Language::Python::Virtualenv

  desc "Lint your Python code for style and logical errors"
  homepage "http://flake8.pycqa.org/"
  url "https://gitlab.com/pycqa/flake8/-/archive/3.7.8/flake8-3.7.8.tar.bz2"
  sha256 "c379edcba8b53cc119ac782ecb75c35571bfa440248821a1e1a8b012b289c43c"
  head "https://gitlab.com/PyCQA/flake8.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "44b69dfb14bce44ec3ac46e888921e5541c3802e8f22747e7e554322644dbfcd" => :mojave
    sha256 "e8d3a528c5d7dc767f016e253f1d72f27f713a94f58acd510cb6472debda7f34" => :high_sierra
    sha256 "3c3de620e7966962c807a4c2531a4174da3e3847004a4e782e063c94479a79d3" => :sierra
  end

  depends_on "python"

  resource "entrypoints" do
    url "https://files.pythonhosted.org/packages/b4/ef/063484f1f9ba3081e920ec9972c96664e2edb9fdc3d8669b0e3b8fc0ad7c/entrypoints-0.3.tar.gz"
    sha256 "c70dd71abe5a8c85e55e12c19bd91ccfeec11a6e99044204511f9ed547d48451"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/06/18/fa675aa501e11d6d6ca0ae73a101b2f3571a565e0f7d38e062eec18a91ee/mccabe-0.6.1.tar.gz"
    sha256 "dd8d182285a0fe56bace7f45b5e7d1a6ebcbf524e8f3bd87eb0f125271b8831f"
  end

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/1c/d1/41294da5915f4cae7f4b388cea6c2cd0d6cd53039788635f6875dfe8c72f/pycodestyle-2.5.0.tar.gz"
    sha256 "e40a936c9a450ad81df37f549d676d127b1b66000a6c500caa2b085bc0ca976c"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/52/64/87303747635c2988fcaef18af54bfdec925b6ea3b80bcd28aaca5ba41c9e/pyflakes-2.1.1.tar.gz"
    sha256 "d976835886f8c5b31d47970ed689944a0262b5f3afa00a5a7b4dc81e5449f8a2"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    resource("entrypoints").stage do
      # Without removing this file, `pip` will ignore the `setup.py` file and
      # attempt to download the [`flit`](https://github.com/takluyver/flit)
      # build system.
      rm_f "pyproject.toml"
      venv.pip_install Pathname.pwd
    end
    (resources.map(&:name).to_set - ["entrypoints"]).each do |r|
      venv.pip_install resource(r)
    end
    venv.pip_install_and_link buildpath
  end

  test do
    xy = Language::Python.major_minor_version "python3"
    # flake8 version 3.7.8 will fail this test with `E203` warnings.
    # Adding `E203` to the list of ignores makes the test pass.
    # Remove the customized ignore list once the problem is fixed upstream.
    system "#{bin}/flake8", "#{libexec}/lib/python#{xy}/site-packages/flake8", "--ignore=E121,E123,E126,E226,E24,E704,W503,W504,E203"
  end
end

class Flake8 < Formula
  include Language::Python::Virtualenv

  desc "Lint your Python code for style and logical errors"
  homepage "http://flake8.pycqa.org/"
  url "https://gitlab.com/pycqa/flake8/-/archive/3.7.6/flake8-3.7.6.tar.gz"
  sha256 "2729990a3ec78ed17a2b6177bed2b18c6bfd152ca8ec20fff500a1e36ba761b4"
  head "https://gitlab.com/PyCQA/flake8.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "b2a2a1252190b9d17890a6447463615ccc8907b7bc339bc80a9c2a078d7db750" => :mojave
    sha256 "1a921c2099df067fe9f396b4f3d62fac2c8b53d35949b8fcbc612301e5029b54" => :high_sierra
    sha256 "9b9b91739ef3de95038f005eeecaf3a55f164b3e1326a24db0e1343ee591ee84" => :sierra
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
    url "https://files.pythonhosted.org/packages/48/6d/7bfd617b21292397e10e24af4cf42947a359b0c425b66f194cf5d14b1444/pyflakes-2.1.0.tar.gz"
    sha256 "5e8c00e30c464c99e0b501dc160b13a14af7f27d4dffb529c556e30a159e231d"
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
    # flake8 version 3.6.0 will fail this test with `E203` warnings.
    # Adding `E203` to the list of ignores makes the test pass.
    # Remove the customized ignore list once the problem is fixed upstream.
    system "#{bin}/flake8", "#{libexec}/lib/python#{xy}/site-packages/flake8", "--ignore=E121,E123,E126,E226,E24,E704,W503,W504,E203"
  end
end

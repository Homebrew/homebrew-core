class Jupytext < Formula
  include Language::Python::Virtualenv

  desc "Jupyter notebooks as Markdown documents, Julia, Python or R scripts"
  homepage "https://jupytext.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/13/a5/80c02f307c8ce863cb33e27daf049315e9d96979e14eead700923b5ec9cc/jupytext-1.19.1.tar.gz"
  sha256 "82587c07e299173c70ed5e8ec7e75183edf1be289ed518bab49ad0d4e3d5f433"
  license "MIT"
  head "https://github.com/mwouts/jupytext.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3df1e08b257e02727f81f6661fe657cf2389775cdf95b300bf767155e7994c0f"
    sha256 cellar: :any,                 arm64_sequoia: "b7bc2fff8105591520b0acc8d74e3fb740657b6fcac669e3f9073c49d0749246"
    sha256 cellar: :any,                 arm64_sonoma:  "dc34145af98613877a760952cb3c845c50de95fd8ba642184d2441dfbd256c5e"
    sha256 cellar: :any,                 sonoma:        "0c0192fd18d04e9c60f6f3d30abbc543d3138b722e286198be13a02b7e8e32ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4904e7890cc517fdc33c58e8c97dbfdbfbdf791256d30e2598bd0dea384380e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a14eb817bc0e457b9b693b6c1d5094eb4d6269b7fc60c0e649ffd33c678f1286"
  end

  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  pypi_packages exclude_packages: "rpds-py"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "fastjsonschema" do
    url "https://files.pythonhosted.org/packages/20/b5/23b216d9d985a956623b6bd12d4086b60f0059b27799f23016af04a74ea1/fastjsonschema-2.21.2.tar.gz"
    sha256 "b1eb43748041c880796cd077f1a07c3d94e93ae84bba5ed36800a33554ae05de"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "jupyter-core" do
    url "https://files.pythonhosted.org/packages/02/49/9d1284d0dc65e2c757b74c6687b6d319b02f822ad039e5c512df9194d9dd/jupyter_core-5.9.1.tar.gz"
    sha256 "4d09aaff303b9566c3ce657f580bd089ff5c91f5f89cf7d8846c3cdf465b5508"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/b2/fd/a756d36c0bfba5f6e39a1cdbdbfdd448dc02692467d83816dff4592a1ebc/mdit_py_plugins-0.5.0.tar.gz"
    sha256 "f4918cb50119f50446560513a8e311d574ff6aaed72606ddae6d35716fe809c6"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "nbformat" do
    url "https://files.pythonhosted.org/packages/6d/fd/91545e604bc3dad7dca9ed03284086039b294c6b3d75c0d2fa45f9e9caf3/nbformat-5.10.4.tar.gz"
    sha256 "322168b14f937a5d11362988ecac2a4952d3d8e3a2cbeb2319584631226d5b3a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/cf/86/0248f086a84f01b37aaec0fa567b397df1a119f73c16f6c7a9aac73ea309/platformdirs-4.5.1.tar.gz"
    sha256 "61d5cdcc6065745cdd94f0f878977f8de9437be93de97c1c12f853c9c0cdcbda"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "traitlets" do
    url "https://files.pythonhosted.org/packages/eb/79/72064e6a701c2183016abbbfedaba506d81e30e232a68c9f0d6f6fcd1574/traitlets-5.14.3.tar.gz"
    sha256 "9ed0579d3502c94b4b3732ac120375cda96f923114522847de4b3bb98b96b6b7"
  end

  def install
    # Remove unused build requirements for optional JupyterLab extension
    # that cause a circular build dependency: https://github.com/jupyterlab/jupyterlab_pygments/issues/23
    inreplace "pyproject.toml", 'requires = ["hatchling>=1.5.0", "hatch-jupyter-builder>=0.5", "jupyterlab>=4"]',
                                'requires = ["hatchling>=1.5.0"]'
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jupytext --version")

    (testpath/"notebook.ipynb").write <<~JSON
      {
        "cells": [
          {
            "cell_type": "code",
            "execution_count": null,
            "metadata": {},
            "outputs": [],
            "source": [
              "print('Hello, World!')"
            ]
          }
        ],
        "metadata": {},
        "nbformat": 4,
        "nbformat_minor": 5
      }
    JSON

    system bin/"jupytext", "--to", "py", "notebook.ipynb"
    assert_path_exists testpath/"notebook.py"
    assert_match "print('Hello, World!')", (testpath/"notebook.py").read
  end
end

class Jupytext < Formula
  include Language::Python::Virtualenv

  desc "Jupyter notebooks as Markdown documents, Julia, Python or R scripts"
  homepage "https://jupytext.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/15/14/41faf71e168fcc6c48268f0fc67ba0d6acf6ee4e2c5c785c2bccb967c29d/jupytext-1.17.3.tar.gz"
  sha256 "8b6dae76d63c95cad47b493c38f0d9c74491fb621dcd0980abfcac4c8f168679"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f78fd6fb325fd7480f1a6a697b66ae482e423f7b5a91d35bf780ec92639060e7"
    sha256 cellar: :any,                 arm64_sequoia: "1754cc57f359f23b0320bcfcb7073c5cca6d0924d7ebb7735ae8e2682a4695c7"
    sha256 cellar: :any,                 arm64_sonoma:  "5a9a1dff97b7173409c583fc788074fd3c832c5fbf07aa9a4cde38240bf93e42"
    sha256 cellar: :any,                 arm64_ventura: "d00d1ccf1144db621c245caad25c283226b9a65b68dda0917093ef196d9c3cbd"
    sha256 cellar: :any,                 sonoma:        "97aa86e6a9377d569ada46e118be214ff530943b789c068b64768bf835fd72ce"
    sha256 cellar: :any,                 ventura:       "60dbeb38482ed74da5d65bc3f416ec38c2a119d7852c441f6a5da54ecff151fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9c9a1ac5f2d8a25257101ec518f39e9b4a19ac0a54c7038ba25806af3108c09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9aaea993a981c349a348a17d128652d662ac2d630a8c6987da0e112bcf72830"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "fastjsonschema" do
    url "https://files.pythonhosted.org/packages/20/b5/23b216d9d985a956623b6bd12d4086b60f0059b27799f23016af04a74ea1/fastjsonschema-2.21.2.tar.gz"
    sha256 "b1eb43748041c880796cd077f1a07c3d94e93ae84bba5ed36800a33554ae05de"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/74/69/f7185de793a29082a9f3c7728268ffb31cb5095131a9c139a74078e27336/jsonschema-4.25.1.tar.gz"
    sha256 "e4a9655ce0da0c0b67a085847e00a3a51449e1157f4f75e9fb5aa545e122eb85"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/bf/ce/46fbd9c8119cfc3581ee5643ea49464d168028cfb5caff5fc0596d0cf914/jsonschema_specifications-2025.4.1.tar.gz"
    sha256 "630159c9f4dbea161a6a2205c3011cc4f18ff381b189fff48bb39b9bf26ae608"
  end

  resource "jupyter-core" do
    url "https://files.pythonhosted.org/packages/99/1b/72906d554acfeb588332eaaa6f61577705e9ec752ddb486f302dafa292d9/jupyter_core-5.8.1.tar.gz"
    sha256 "0a5f9706f70e64786b75acba995988915ebd4601c8a52e534a40b51c95f59941"
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
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/23/e8/21db9c9987b0e728855bd57bff6984f67952bea55d6f75e055c46b5383e8/platformdirs-4.4.0.tar.gz"
    sha256 "ca753cf4d81dc309bc67b0ea38fd15dc97bc30ce419a7f58d13eb3bf14c4febf"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/2f/db/98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2/referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/e9/dd/2c0cbe774744272b0ae725f44032c77bdcab6e8bcf544bffa3b6e70c8dba/rpds_py-0.27.1.tar.gz"
    sha256 "26a1c73171d10b7acccbded82bf6a586ab8203601e565badc74bbbf8bc5a10f8"
  end

  resource "traitlets" do
    url "https://files.pythonhosted.org/packages/eb/79/72064e6a701c2183016abbbfedaba506d81e30e232a68c9f0d6f6fcd1574/traitlets-5.14.3.tar.gz"
    sha256 "9ed0579d3502c94b4b3732ac120375cda96f923114522847de4b3bb98b96b6b7"
  end

  def install
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

class Jupyterlab < Formula
  include Language::Python::Virtualenv

  desc "Interactive environments for writing and running code"
  homepage "https://jupyter.org/"
  url "https://files.pythonhosted.org/packages/64/b4/65b608ca9d7a78adf403bb1dd6ca0c7b3ce2cedbe1255184b3dc88436723/jupyterlab-2.1.2.tar.gz"
  sha256 "380c29d674f6dcf8e380615334c7813bb4feb7bbb6222baf1d4c9f8318f4b104"

  bottle do
    cellar :any
    sha256 "672ea0309603f7b8fe886a29b75c5d6dbfd89987be4aa8c3e658342e74b052fc" => :catalina
    sha256 "0ee950175a14a431f706fff95431619e7c0732d728e62d1d94ed627f505aa332" => :mojave
    sha256 "82dc5744312b7a0f11bfddb08bd5f1ba04c583ad35b53a1cc73d309fb499a281" => :high_sierra
  end

  depends_on "ipython"
  depends_on "node"
  depends_on "pandoc"
  depends_on "python@3.8"
  depends_on "zeromq"

  uses_from_macos "expect" => :test

  resource "appnope" do
    url "https://files.pythonhosted.org/packages/26/34/0f3a5efac31f27fabce64645f8c609de9d925fe2915304d1a40f544cff0e/appnope-0.1.0.tar.gz"
    sha256 "8b995ffe925347a2138d7ac0fe77155e4311a0ea6d6da4f5128fe4b3cbe5ed71"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/98/c3/2c227e66b5e896e15ccdae2e00bbc69aa46e9a8ce8869cc5fa96310bf612/attrs-19.3.0.tar.gz"
    sha256 "f7b7ce16570fe9965acd6d30101a28f62fb4a7f9e926b3bbc9b61f8b04247e72"
  end

  resource "backcall" do
    url "https://files.pythonhosted.org/packages/84/71/c8ca4f5bb1e08401b916c68003acf0a0655df935d74d93bf3f3364b310e0/backcall-0.1.0.tar.gz"
    sha256 "38ecd85be2c1e78f77fd91700c76e14667dc21e2713b63876c0eb901196e01e4"
  end

  resource "bleach" do
    url "https://files.pythonhosted.org/packages/3f/63/8665338373efc632dc60de6526460ba33fa21bae1eaa5e4f37159ca38e94/bleach-3.1.4.tar.gz"
    sha256 "e78e426105ac07026ba098f04de8abe9b6e3e98b5befbf89b51a5ef0a4292b03"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/b8/e2/a3a86a67c3fc8249ed305fc7b7d290ebe5e4d46ad45573884761ef4dea7b/certifi-2020.4.5.1.tar.gz"
    sha256 "51fcb31174be6e6664c5f69e3e1691a2d72a1a12e90f872cbdb1567eb47b6519"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/da/93/84fa12f2dc341f8cf5f022ee09e109961055749df2d0c75c5f98746cfe6c/decorator-4.4.2.tar.gz"
    sha256 "e3a62f0520172440ca0dcc823749319382e377f37f140a0b99ef45fecb84bfe7"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/a4/5f/f8aa58ca0cf01cbcee728abc9d88bfeb74e95e6cb4334cfd5bed5673ea77/defusedxml-0.6.0.tar.gz"
    sha256 "f684034d135af4c6cbb949b8a4d2ed61634515257a67299e5f940fbaa34377f5"
  end

  resource "entrypoints" do
    url "https://files.pythonhosted.org/packages/b4/ef/063484f1f9ba3081e920ec9972c96664e2edb9fdc3d8669b0e3b8fc0ad7c/entrypoints-0.3.tar.gz"
    sha256 "c70dd71abe5a8c85e55e12c19bd91ccfeec11a6e99044204511f9ed547d48451"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cb/19/57503b5de719ee45e83472f339f617b0c01ad75cba44aba1e4c97c2b0abd/idna-2.9.tar.gz"
    sha256 "7588d1c14ae4c77d74036e8c22ff447b26d0fde8f007354fd48a7814db15b7cb"
  end

  resource "ipykernel" do
    url "https://files.pythonhosted.org/packages/c1/43/a7c6398e3ca3748781f7cd13c1b0d17725ee5bd3c1df39a3e8d66341ca3a/ipykernel-5.2.1.tar.gz"
    sha256 "2937373c356fa5b634edb175c5ea0e4b25de8008f7c194f2d49cfbd1f9c970a8"
  end

  resource "ipython" do
    url "https://files.pythonhosted.org/packages/76/d4/13001e8671e8b012ec25acb9a695d3271ceed2dc6aa8f94103a6dd0c4577/ipython-7.13.0.tar.gz"
    sha256 "ca478e52ae1f88da0102360e57e528b92f3ae4316aabac80a2cd7f7ab2efb48a"
  end

  resource "ipython_genutils" do
    url "https://files.pythonhosted.org/packages/e8/69/fbeffffc05236398ebfcfb512b6d2511c622871dca1746361006da310399/ipython_genutils-0.2.0.tar.gz"
    sha256 "eb2e116e75ecef9d4d228fdc66af54269afa26ab4463042e33785b887c628ba8"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/e3/5b/65ff9c102d92bf719dfaeff57bc8074d68f26ea480005704a956da995799/jedi-0.17.0.tar.gz"
    sha256 "df40c97641cb943661d2db4c33c2e1ff75d491189423249e989bcea4464f3030"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/64/a7/45e11eebf2f15bf987c3bc11d37dcc838d9dc81250e67e4c5968f6008b6c/Jinja2-2.11.2.tar.gz"
    sha256 "89aab215427ef59c34ad58735269eb58b1a5808103067f7bb9d5836c651b3bb0"
  end

  resource "json5" do
    url "https://files.pythonhosted.org/packages/91/06/fd24717500706cfe979f387daa220eb30b8632684de84083c1e4699ff440/json5-0.9.4.tar.gz"
    sha256 "2ebfad1cd502dca6aecab5b5c36a21c732c3461ddbc412fb0e9a52b07ddfe586"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/69/11/a69e2a3c01b324a77d3a7c0570faa372e8448b666300c4117a516f8b1212/jsonschema-3.2.0.tar.gz"
    sha256 "c8a85b28d377cc7737e46e2d9f2b4f44ee3c0e1deac6bf46ddefc7187d30797a"
  end

  resource "jupyter-client" do
    url "https://files.pythonhosted.org/packages/fa/84/440ef480bb829ac648f8e9d7f17c9e2b2470de18ccab989ffa25a64c8c9f/jupyter_client-6.1.3.tar.gz"
    sha256 "3a32fa4d0b16d1c626b30c3002a62dfd86d6863ed39eaba3f537fade197bb756"
  end

  resource "jupyter-console" do
    url "https://files.pythonhosted.org/packages/e9/54/da5cd731e5845b529838b42666282fd59b282691407f529580383c62d859/jupyter_console-6.1.0.tar.gz"
    sha256 "6f6ead433b0534909df789ea64f0a14cdf9b6b2360757756f08182be4b9e431b"
  end

  resource "jupyter-core" do
    url "https://files.pythonhosted.org/packages/28/64/8bdde111be57a2a3d54376db29b5f25ab9c68ffd3d6554989db24d5c1b7a/jupyter_core-4.6.3.tar.gz"
    sha256 "394fd5dd787e7c8861741880bdf8a00ce39f95de5d18e579c74b882522219e7e"
  end

  resource "jupyterlab-server" do
    url "https://files.pythonhosted.org/packages/32/eb/3d6f657e35dda1b78754ee26f5dcf877c6c69f7489e76839c3a292387fa0/jupyterlab_server-1.1.1.tar.gz"
    sha256 "b5921872746b1ca109d1852196ed11e537f8aad67a1933c1d4a8ac63f8e61cca"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"
    sha256 "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"
  end

  resource "mistune" do
    url "https://files.pythonhosted.org/packages/2d/a4/509f6e7783ddd35482feda27bc7f72e65b5e7dc910eca4ab2164daf9c577/mistune-0.8.4.tar.gz"
    sha256 "59a3429db53c50b5c6bcc8a07f8848cb00d7dc8bdb431a4ab41920d201d4756e"
  end

  resource "nbconvert" do
    url "https://files.pythonhosted.org/packages/04/f2/299fa4b15155ecbe2aefe7412249f0dd91f953b7a9b37c336317d564a1ca/nbconvert-5.6.1.tar.gz"
    sha256 "21fb48e700b43e82ba0e3142421a659d7739b65568cc832a13976a77be16b523"
  end

  resource "nbformat" do
    url "https://files.pythonhosted.org/packages/bb/b5/6a1c886c7d3f4794e59bc8d1045363ede95a0dc49b6f38fdd037ff30e51c/nbformat-5.0.6.tar.gz"
    sha256 "049af048ed76b95c3c44043620c17e56bc001329e07f83fec4f177f0e3d7b757"
  end

  resource "notebook" do
    url "https://files.pythonhosted.org/packages/a9/c8/77ab314f1a0102c50762efcc2b58be99780ddffb88bcd5820e2715e1799e/notebook-6.0.3.tar.gz"
    sha256 "47a9092975c9e7965ada00b9a20f0cf637d001db60d241d479f53c0be117ad48"
  end

  resource "pandocfilters" do
    url "https://files.pythonhosted.org/packages/4c/ea/236e2584af67bb6df960832731a6e5325fd4441de001767da328c33368ce/pandocfilters-1.4.2.tar.gz"
    sha256 "b3dd70e169bb5449e6bc6ff96aea89c5eea8c5f6ab5e207fc2f521a2cf4a0da9"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/fe/24/c30eb4be8a24b965cfd6e2e6b41180131789b44042112a16f9eb10c80f6e/parso-0.7.0.tar.gz"
    sha256 "908e9fae2144a076d72ae4e25539143d40b8e3eafbaeae03c1bfe226f4cdf12c"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/e5/9b/ff402e0e930e70467a7178abb7c128709a30dfb22d8777c043e501bc1b10/pexpect-4.8.0.tar.gz"
    sha256 "fc65a43959d153d0114afe13997d439c22823a27cefceb5ff35c2178c6784c0c"
  end

  resource "pickleshare" do
    url "https://files.pythonhosted.org/packages/d8/b6/df3c1c9b616e9c0edbc4fbab6ddd09df9535849c64ba51fcb6531c32d4d8/pickleshare-0.7.5.tar.gz"
    sha256 "87683d47965c1da65cdacaf31c8441d12b8044cdec9aca500cd78fc2c683afca"
  end

  resource "prometheus_client" do
    url "https://files.pythonhosted.org/packages/b3/23/41a5a24b502d35a4ad50a5bb7202a5e1d9a0364d0c12f56db3dbf7aca76d/prometheus_client-0.7.1.tar.gz"
    sha256 "71cd24a2b3eb335cb800c7159f423df1bd4dcd5171b234be15e3f31ec9f622da"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/69/19/3aa4bf17e1cbbdfe934eb3d5b394ae9a0a7fb23594a2ff27e0fdaf8b4c59/prompt_toolkit-3.0.5.tar.gz"
    sha256 "563d1a4140b63ff9dd587bda9557cffb2fe73650205ab6f4383092fb882e7dc8"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/7d/2d/e4b8733cf79b7309d84c9081a4ab558c89d8c89da5961bf4ddb050ca1ce0/ptyprocess-0.6.0.tar.gz"
    sha256 "923f299cc5ad920c68f2bc0bc98b75b9f838b93b599941a6b63ddbc2476394c0"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/6e/4d/4d2fe93a35dfba417311a4ff627489a947b01dc0cc377a3673c00cf7e4b2/Pygments-2.6.1.tar.gz"
    sha256 "647344a061c249a3b74e230c739f434d7ea4d8b1d5f3721bc0f3558049b38f44"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/9f/0d/cbca4d0bbc5671822a59f270e4ce3f2195f8a899c97d0d5abb81b191efb5/pyrsistent-0.16.0.tar.gz"
    sha256 "28669905fe725965daa16184933676547c5bb40a5153055a8dee2a4bd7933ad3"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/16/4c/762c2c3063c4d45baf4a49acea7a4f561f7b78a45cd04b58d63f4c5f6b8d/pyzmq-19.0.0.tar.gz"
    sha256 "5e1f65e576ab07aed83f444e201d86deb01cd27dcf3f37c727bc8729246a60a8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/f5/4f/280162d4bd4d8aad241a21aecff7a6e46891b905a4341e7ab549ebaf7915/requests-2.23.0.tar.gz"
    sha256 "b3f43d496c6daba4493e7c431722aeb7dbc6288f52a6e04e7b6023b0247817e6"
  end

  resource "Send2Trash" do
    url "https://files.pythonhosted.org/packages/13/2e/ea40de0304bb1dc4eb309de90aeec39871b9b7c4bd30f1a3cdcb3496f5c0/Send2Trash-1.5.0.tar.gz"
    sha256 "60001cc07d707fe247c94f74ca6ac0d3255aabcb930529690897ca2a39db28b2"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
    sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
  end

  resource "terminado" do
    url "https://files.pythonhosted.org/packages/13/5b/57e995382718d176aba6168632bd15cf5371a7b1205c83a7e4aae0bc6c2e/terminado-0.8.3.tar.gz"
    sha256 "4804a774f802306a7d9af7322193c5390f1da0abb429e082a10ef1d46e6fb2c2"
  end

  resource "testpath" do
    url "https://files.pythonhosted.org/packages/2c/b3/5d57205e896d8998d77ad12aa42ebce75cd97d8b9a97d00ba078c4c9ffeb/testpath-0.4.4.tar.gz"
    sha256 "60e0a3261c149755f4399a1fff7d37523179a70fdc3abdf78de9fc2604aeec7e"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/95/84/119a46d494f008969bf0c775cb2c6b3579d3c4cc1bb1b41a022aa93ee242/tornado-6.0.4.tar.gz"
    sha256 "0fe2d45ba43b00a41cd73f8be321a44936dc1aba233dee979f17a042b83eb6dc"
  end

  resource "traitlets" do
    url "https://files.pythonhosted.org/packages/75/b0/43deb021bc943f18f07cbe3dac1d681626a48997b7ffa1e7fb14ef922b21/traitlets-4.3.3.tar.gz"
    sha256 "d023ee369ddd2763310e4c3eae1ff649689440d4ae59d7485eb4cfbbe3e359f7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/05/8c/40cd6949373e23081b3ea20d5594ae523e681b6f472e600fbc95ed046a36/urllib3-1.25.9.tar.gz"
    sha256 "3018294ebefce6572a474f0604c2021e33b3fd8006ecd11d62107a5d2a963527"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/25/9d/0acbed6e4a4be4fc99148f275488580968f44ddb5e69b8ceb53fc9df55a0/wcwidth-0.1.9.tar.gz"
    sha256 "ee73862862a156bf77ff92b09034fc4825dd3af9cf81bc5b360668d425f3c5f1"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  def install
    venv = virtualenv_create(libexec, Formula["python@3.8"].opt_bin/"python3")
    ENV["JUPYTER_PATH"] = etc/"jupyter"

    # gather packages to link based on options
    linked = %w[jupyter-core jupyter-client nbformat ipykernel jupyter-console nbconvert notebook]
    dependencies = resources.map(&:name).to_set - linked
    dependencies.each do |r|
      venv.pip_install resource(r)
    end
    venv.pip_install_and_link linked
    venv.pip_install_and_link buildpath

    # remove bundled kernel
    rm_rf Dir["#{libexec}/share/jupyter/kernels"]

    # install completion
    resource("jupyter-core").stage do
      bash_completion.install "examples/jupyter-completion.bash" => "jupyter"
      zsh_completion.install "examples/completions-zsh" => "_jupyter"
    end
  end

  def caveats
    <<~EOS
      Additional kernels can be installed into the shared jupyter directory
        #{etc}/jupyter
    EOS
  end

  test do
    system bin/"jupyter-console --help"
    assert_match "python3", shell_output("#{bin}/jupyter kernelspec list")

    (testpath/"console.exp").write <<~EOS
      spawn #{bin}/jupyter-console
      expect "In "
      send "exit\r"
    EOS
    assert_match "Jupyter console", shell_output("expect -f console.exp")

    (testpath/"notebook.exp").write <<~EOS
      spawn #{bin}/jupyter-notebook --no-browser
      expect "NotebookApp"
    EOS
    assert_match "NotebookApp", shell_output("expect -f notebook.exp")

    (testpath/"nbconvert.ipynb").write <<~EOS
      {
        "cells": []
      }
    EOS
    system bin/"jupyter-nbconvert", "nbconvert.ipynb"
    assert_predicate testpath/"nbconvert.html", :exist?, "Failed to export HTML"

    assert_match "-F _jupyter",
      shell_output("source #{bash_completion}/jupyter && complete -p jupyter")

    version_regexp = Regexp.quote(version.to_s)

    # Ensure that jupyter can load the jupyter lab package.
    assert_match /^jupyter lab *: #{version_regexp}$/,
      shell_output(bin/"jupyter --version")

    # Ensure that jupyter-lab binary was installed by pip.
    assert_match /^#{version_regexp}$/,
      shell_output(bin/"jupyter-lab --version")
  end
end

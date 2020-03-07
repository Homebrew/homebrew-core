class Jupyterlab < Formula
  include Language::Python::Virtualenv

  desc "Interactive environments for writing and running code"
  homepage "https://jupyter.org/"
  url "https://files.pythonhosted.org/packages/f8/75/4e482416afe8f6b36cb5b38b339ea6300cde531796a864df93da7d32418f/jupyterlab-2.0.1.tar.gz"
  sha256 "5d1a833a9e49e6d90d68191917cb16a97ff4ec668c26c85d33ebce629df14141"

  bottle do
    cellar :any
    sha256 "6bb8838025f73b046a476c55ebe601d3730b32abe4ccb889600c2808abbcf356" => :catalina
    sha256 "354fe85e83f5dbe18d9ad6869493b80c1628a83e58c1c0e78393518d7bb0c15a" => :mojave
    sha256 "6bc436b5f03f672c6a0d45e7c665e4a5bf6223ddf388b43a0cbb7f05f693c62e" => :high_sierra
  end

  depends_on "ipython"
  depends_on "node"
  depends_on "pandoc"
  depends_on "python"
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
    url "https://files.pythonhosted.org/packages/8d/94/1b236a95e948b9074264a574fbc45f24963fffd0920ccbf74ecce7e347ca/bleach-3.1.1.tar.gz"
    sha256 "aa8b870d0f46965bac2c073a93444636b0e1ca74e9777e34f03dd494b8a59d48"
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

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/0d/e4/638f3bde506b86f62235c595073066e7b8472fc9ee2b8c6491347f31d726/importlib_metadata-1.5.0.tar.gz"
    sha256 "06f5b3a99029c7134207dd882428a66992a9de2bef7c2b699b5641f9886c3302"
  end

  resource "ipykernel" do
    url "https://files.pythonhosted.org/packages/3a/a4/335439bbaaccfe9d88e09f3df6ba391938a2e3e175ec92ff040462125c68/ipykernel-5.1.4.tar.gz"
    sha256 "7f1f01df22f1229c8879501057877ccaf92a3b01c1d00db708aad5003e5f9238"
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
    url "https://files.pythonhosted.org/packages/5a/b7/d7bdce4e0ae654125404b397b293ec8a0060a55c9e860794538701b19653/jedi-0.16.0.tar.gz"
    sha256 "d5c871cb9360b414f981e7072c52c33258d598305280fef91c6cae34739d65d5"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/d8/03/e491f423379ea14bb3a02a5238507f7d446de639b623187bccc111fbecdf/Jinja2-2.11.1.tar.gz"
    sha256 "93187ffbc7808079673ef52771baa950426fd664d3aad1d0fa3e95644360e250"
  end

  resource "json5" do
    url "https://files.pythonhosted.org/packages/68/91/ed7d64939b9d2d89398a7985b5b9c70bf0445eb87836873f60aa72370f9d/json5-0.9.2.tar.gz"
    sha256 "45e4223cabc69d97a57407743dec2af9316c59e1d865836a026ad71c93bfea5a"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/69/11/a69e2a3c01b324a77d3a7c0570faa372e8448b666300c4117a516f8b1212/jsonschema-3.2.0.tar.gz"
    sha256 "c8a85b28d377cc7737e46e2d9f2b4f44ee3c0e1deac6bf46ddefc7187d30797a"
  end

  resource "jupyter-client" do
    url "https://files.pythonhosted.org/packages/b9/ae/6abdd7d5df5a3af23b9c7ee1a509b7606eeb17f5857bb97de93bf92cf0dc/jupyter_client-6.0.0.tar.gz"
    sha256 "1fac6e3be1e797aea33d5cd1cfa568ff1ee71e01180bc89f64b24ee274f1f126"
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
    url "https://files.pythonhosted.org/packages/74/e9/9b148991925148b7b27fa4b88be4ac778229db32b682a2ef273f42a8746b/jupyterlab_server-1.0.7.tar.gz"
    sha256 "12381712f2e70b68442c03046b3afa6483dad4ccae9f47673ffe8a808cefd8e2"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"
    sha256 "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"
  end

  resource "mistune" do
    url "https://files.pythonhosted.org/packages/2d/a4/509f6e7783ddd35482feda27bc7f72e65b5e7dc910eca4ab2164daf9c577/mistune-0.8.4.tar.gz"
    sha256 "59a3429db53c50b5c6bcc8a07f8848cb00d7dc8bdb431a4ab41920d201d4756e"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/a0/47/6ff6d07d84c67e3462c50fa33bf649cda859a8773b53dc73842e84455c05/more-itertools-8.2.0.tar.gz"
    sha256 "b1ddb932186d8a6ac451e1d95844b382f55e12686d51ca0c68b6f61f2ab7a507"
  end

  resource "nbconvert" do
    url "https://files.pythonhosted.org/packages/04/f2/299fa4b15155ecbe2aefe7412249f0dd91f953b7a9b37c336317d564a1ca/nbconvert-5.6.1.tar.gz"
    sha256 "21fb48e700b43e82ba0e3142421a659d7739b65568cc832a13976a77be16b523"
  end

  resource "nbformat" do
    url "https://files.pythonhosted.org/packages/c8/5f/92d74702213f0a2d85b2c91158ce1f96fbc003b8c515a8ec5cb39043e7c9/nbformat-5.0.4.tar.gz"
    sha256 "562de41fc7f4f481b79ab5d683279bf3a168858268d4387b489b7b02be0b324a"
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
    url "https://files.pythonhosted.org/packages/e7/43/d1a87101b7d738ffae32951c140fcbca12b35daf11a918e0964a2fd07fbd/parso-0.6.2.tar.gz"
    sha256 "0c5659e0c6eba20636f99a04f469798dca8da279645ce5c387315b2c23912157"
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
    url "https://files.pythonhosted.org/packages/61/c9/56131b4753ef14bffd06754846c63de78b3a868e995763f6410381a6fb98/prompt_toolkit-3.0.4.tar.gz"
    sha256 "ebe6b1b08c888b84c50d7f93dee21a09af39860144ff6130aadbd61ae8d29783"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/7d/2d/e4b8733cf79b7309d84c9081a4ab558c89d8c89da5961bf4ddb050ca1ce0/ptyprocess-0.6.0.tar.gz"
    sha256 "923f299cc5ad920c68f2bc0bc98b75b9f838b93b599941a6b63ddbc2476394c0"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/cb/9f/27d4844ac5bf158a33900dbad7985951e2910397998e85712da03ce125f0/Pygments-2.5.2.tar.gz"
    sha256 "98c8aa5a9f778fcd1026a17361ddaf7330d1b7c62ae97c3bb0ae73e0b9b6b0fe"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/90/aa/cdcf7ef88cc0f831b6f14c8c57318824c9de9913fe8de38e46a98c069a35/pyrsistent-0.15.7.tar.gz"
    sha256 "cdc7b5e3ed77bed61270a47d35434a30617b9becdf2478af76ad2c6ade307280"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/16/4c/762c2c3063c4d45baf4a49acea7a4f561f7b78a45cd04b58d63f4c5f6b8d/pyzmq-19.0.0.tar.gz"
    sha256 "5e1f65e576ab07aed83f444e201d86deb01cd27dcf3f37c727bc8729246a60a8"
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

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/5e/33/92333eb80be0c96385dee338f30b53e24a8b415d5785e225d789b3f90feb/wcwidth-0.1.8.tar.gz"
    sha256 "f28b3e8a6483e5d49e7f8949ac1a78314e740333ae305b4ba5defd3e74fb37a8"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/ce/8c/2c5f7dc1b418f659d36c04dec9446612fc7b45c8095cc7369dd772513055/zipp-3.1.0.tar.gz"
    sha256 "c599e4d75c98f6798c509911d08a22e6c021d074469042177c8c86fb92eefd96"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    ENV["JUPYTER_PATH"] = etc/"jupyter"

    # gather packages to link based on options
    linked = %w[jupyter-core jupyter-client nbformat ipykernel jupyter-console
                nbconvert notebook]
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

  def caveats; <<~EOS
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

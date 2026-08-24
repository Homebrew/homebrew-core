class Fava < Formula
  include Language::Python::Virtualenv

  desc "Web interface for the double-entry bookkeeping software Beancount"
  homepage "https://beancount.github.io/fava/"
  url "https://files.pythonhosted.org/packages/3d/06/2c40e01ea4b2e52d7ec7d96aba7c971ce4c32d8fc91a6e781ad069bc4f50/fava-1.30.16.tar.gz"
  sha256 "447425cca159e34dfb230e5c93d5af9e202f366fc4508dc398b13e126c8f9c37"
  license "MIT"
  head "https://github.com/beancount/fava.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b31bd43086f00e3d07a9c8cea860002e2ba7e07fefe4039e905f688377684908"
    sha256 cellar: :any, arm64_sequoia: "d5daff18b1e78f52542c165c8f4fc6e1d44d6078067ceeeeedcf767fb2a42144"
    sha256 cellar: :any, arm64_sonoma:  "46e3be0f80cd7fb8d0b94ae2fbe1c4edaa9147c3fb7b0a162ff56c308ae28331"
    sha256 cellar: :any, sonoma:        "75d540099505fa77094f26df6e3ccea981023d6ec99432786623322ade3708e6"
    sha256 cellar: :any, arm64_linux:   "176e10696b74c22b6b13e46b7cc8e034ad6217f614f6c79e47584dd12bfed247"
    sha256 cellar: :any, x86_64_linux:  "279ef935b783af73fcbad9bd0e121f0d55a2ce46815cff7ef43f11a8793fd89c"
  end

  depends_on "bison" => :build # for beancount
  depends_on "meson" => :build # for beancount
  depends_on "ninja" => :build # for beancount
  depends_on "rust" => :build # for watchfiles
  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  uses_from_macos "flex" => :build # for beancount
  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  on_linux do
    depends_on "patchelf" => :build # for beancount
  end

  pypi_packages exclude_packages: "certifi"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/61/cc/a381afa6efea9f496eff839d4a6a1aed3bfafc7b3ab4b0d1b243a12573dd/anyio-4.14.2.tar.gz"
    sha256 "cfa139f3ed1a23ee8f88a145ddb5ac7605b8bbfd8592baacd7ce3d8bb4313c7f"
  end

  resource "babel" do
    url "https://files.pythonhosted.org/packages/7d/b2/51899539b6ceeeb420d40ed3cd4b7a40519404f9baf3d4ac99dc413a834b/babel-2.18.0.tar.gz"
    sha256 "b80b99a14bd085fcacfa15c9165f651fbb3406e66cc603abf11c5750937c992d"
  end

  resource "beancount" do
    url "https://files.pythonhosted.org/packages/eb/21/ed48e671a5e474c620762a7ea9c6b7f402f847d74dd2b73ceb5d2dec79a3/beancount-3.2.3.tar.gz"
    sha256 "f52c4d237bcb092cbf02a29373d3e59d95349c2828a91491818ae437ee220f74"
  end

  resource "beangulp" do
    url "https://files.pythonhosted.org/packages/39/e6/5b3307d3035439f60da4372395edec8261852a083278fdbf3a96df0e6395/beangulp-0.2.0.tar.gz"
    sha256 "5c908c45c62c07c4efadd0b03d3cdd145ad3b5e2bab5f5f277e0093a5891241a"
  end

  resource "beanquery" do
    url "https://files.pythonhosted.org/packages/7c/90/801eec23a07072dcf8df061cb6f27be6045e08c12a90b287e872ce0a12d3/beanquery-0.2.0.tar.gz"
    sha256 "2d72b50a39003435c7fed183666572b8ea878b9860499d0f196b38469384cd2c"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/43/65/318323f98dbee45d42dff61d8f047181bc6f2268a9068cfad035a46be5af/beautifulsoup4-4.15.0.tar.gz"
    sha256 "288e3ca7d54b06f2ac191970bc275c1939cb46d450b255bf6718b04aa37ab4f7"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/21/28/9b3f50ce0e048515135495f198351908d99540d69bfdc8c1d15b73dc55ce/blinker-1.9.0.tar.gz"
    sha256 "b4ce2265a7abece45e7cc896e98dbebe6cead56bcf805a3d23136d145f5445bf"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/b1/51/cd61c567092a6cec796144510a68aff158ebfc1df82950a45bae65f28413/chardet-7.6.0.tar.gz"
    sha256 "93d9df6089ded42ed1fe9f57e272c0b74bd0464d45c0c7d50f09f26f31105c3c"
  end

  resource "cheroot" do
    url "https://files.pythonhosted.org/packages/68/e4/5c2020b60a55aca8d79ed55b62ad1cd7fc47ea44ad6b584e83f5f1bf58b0/cheroot-11.1.2.tar.gz"
    sha256 "bfb70c49663f63b0440f2b54dbc6b0d1650e56dfe4e2641f59b2c6f727b44aca"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/26/00/35d85dcce6c57fdc871f3867d465d780f302a175ea360f62533f12b27e2b/flask-3.1.3.tar.gz"
    sha256 "0ef0e52b8a9cd932855379197dd8f94047b359ca0a78695144304cb45f87c9eb"
  end

  resource "flask-babel" do
    url "https://files.pythonhosted.org/packages/58/1a/4c65e3b90bda699a637bfb7fb96818b0a9bbff7636ea91aade67f6020a31/flask_babel-4.0.0.tar.gz"
    sha256 "dbeab4027a3f4a87678a11686496e98e1492eb793cbdd77ab50f4e9a2602a593"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/5f/f7/abb373e5757eaec4b922b92f97ec8d6d7e057cf06778247604fbc4e7c3f3/idna-3.19.tar.gz"
    sha256 "5e0811a4383b21dc5838069f801c4fb62113b7447663d2530d2bd6e77b49bf15"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/9c/cb/8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31d/itsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/6c/1f/c23395957d41ccf27c4e535c3d334c4051e5395b3752057ba4cbaec35c56/jaraco_functools-4.6.0.tar.gz"
    sha256 "880c577ec9720b3a052d5bc611fb9f2269b3d87902ef42440df443b88e443280"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/05/3b/aab6728cae887456f409b4d75e8a01856e4f04bd510de38052a47768b680/lxml-6.1.1.tar.gz"
    sha256 "ba96ae44888e0185281e937633a743ea90d5a196c6000f82565ebb0580012d40"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/de/1d/f4da6f02cdffe04d6362210b807146a26044c88d839208aec273bb0d9184/more_itertools-11.1.0.tar.gz"
    sha256 "48e8f4d9e7e5878571ecf6f2b4e57634f93cd474cc8cfbd2376f2d11b396e30d"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/da/db/0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130/python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/fb/48/fb042503b6ca6cd271261dc559fd6432f7d8c713153e9ec5c591af4dfc1c/pytz-2026.3.post1.tar.gz"
    sha256 "2211d3fcf9a797d3405cac96ac7f61d80e6a644f72a3309607282fe8a2010c5d"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/20/98/04b13f1ddfb63158025291c02e03eb42fbb7acb51d091d541050eb4e35e8/regex-2026.7.19.tar.gz"
    sha256 "7e77b324909c1617cbb4c668677e2c6ae13f44d7c1de0d4f15f2e3c10f3315b5"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/41/f4/a1ac5ed32f7ed9a088d62a59d410d4c204b3b3815722e2ccfb491fa8251b/simplejson-3.20.2.tar.gz"
    sha256 "5fe7a6ce14d1c300d80d08695b7f7e633de6cd72c80644021874d985b3393649"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/69/99/a6ca3beb3ccacb41fb3321d8a60e5566f9e6467601ef8eba6a17e1b89778/soupsieve-2.9.2.tar.gz"
    sha256 "4a55d8cf158a9c2e587fa4922f1bbb91d68ac829e2d6f25403a85747c71daf74"
  end

  resource "tatsu-lts" do
    url "https://files.pythonhosted.org/packages/d3/81/9ab714191017d23a0e73921e7d869890e5bf6a5eca89dee57d2b76c6c536/tatsu_lts-5.16.0.tar.gz"
    sha256 "40ad376b4ed4e139a8d00d00bd6659d44c3b7546933fb3314132f776bfa1f44f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/cd/41/5e1a4bb12aac5f1493fa1bdc11154eca3b258ca4eba65d39c473fe19d8e9/watchfiles-1.2.0.tar.gz"
    sha256 "c995fba777f1ea992f090f9236e9284cf7a5d1a0130dd5a3d82c598cacd76838"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/dd/b2/381be8cfdee792dd117872481b6e378f85c957dd7c5bca38897b08f765fd/werkzeug-3.1.8.tar.gz"
    sha256 "9bad61a4268dac112f1c5cd4630a56ede601b6ed420300677a869083d70a4c44"
  end

  def install
    # Mark the bundled frontend as current, https://github.com/beancount/fava/issues/2345
    touch "src/fava/static/app.js"

    venv = virtualenv_install_with_resources(without: "beancount")

    resource("beancount").stage do
      # Skip the PyPI flex/bison wrappers; we already provide system equivalents.
      inreplace "pyproject.toml", /^\s*'(flex|bison)-bin.*\n/, ""
      venv.pip_install Pathname.pwd
    end

    generate_completions_from_executable(bin/"fava", shell_parameter_format: :click)
  end

  test do
    # Find an available port
    port = free_port

    (testpath/"example.ledger").write <<~EOS
      2020-01-01 open Assets:Checking
      2020-01-01 open Equity:Opening-Balances
      2020-01-01 txn "Opening Balance"
        Assets:Checking 10.00 USD
        Equity:Opening-Balances
    EOS

    spawn bin/"fava", "--port=#{port}", testpath/"example.ledger"

    # Wait for fava to start up
    sleep 10
    sleep 10 if OS.mac? && Hardware::CPU.intel?

    cmd = "curl -sIm1 -XGET http://localhost:#{port}/beancount/income_statement/"
    assert_match(/200 OK/m, shell_output(cmd))
  end
end

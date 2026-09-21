class Pelican < Formula
  include Language::Python::Virtualenv

  desc "Static site generator that supports Markdown and reST syntax"
  homepage "https://getpelican.com/"
  url "https://files.pythonhosted.org/packages/c4/8d/da26b77f0d9827d341bdedea357ccb5670717e3a9b4142e3e44c7f34db44/pelican-4.12.0.tar.gz"
  sha256 "3983b5d2dc84c7bdf967154359077a2b78c0bbd2f7dcc55292133a7779609458"
  license "AGPL-3.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1e2ca8a073f5874a010bd2da0b0e387c930aec192886c8d6beb47365107f41c4"
    sha256 cellar: :any, arm64_tahoe:       "fbc9af939d03e778a437a70f00d61f377d20037b8abcb6ff6b760c47bc052709"
    sha256 cellar: :any, arm64_sequoia:     "52e5fc285c1db3a054b49116a6229173da5b24277c7fdbfc2845ef143145a4df"
    sha256 cellar: :any, arm64_linux:       "d968303228488e84dd0061e2f9264955d769a1ee3e706fa4177f49cb7fcb6582"
    sha256 cellar: :any, x86_64_linux:      "2498e4c3d3ac131a525c4895a7573875c28fb1e1c548aff1c2ea55f8abdf8cc5"
  end

  depends_on "rust" => :build # for `watchfiles`
  depends_on "python@3.14"

  pypi_packages package_name: "pelican[markdown]"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a9/d2/f4d173e22df740bc37b1db102b386ba719b66e95b0f0d751f556b387e6d2/anyio-4.15.1.tar.gz"
    sha256 "9f28306018cbd6d329e64a36d58256edff76dd996fe423bc957326e578b82a94"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/21/28/9b3f50ce0e048515135495f198351908d99540d69bfdc8c1d15b73dc55ce/blinker-1.9.0.tar.gz"
    sha256 "b4ce2265a7abece45e7cc896e98dbebe6cead56bcf805a3d23136d145f5445bf"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/39/a4/5180d9afc57e8fca05601dd652bdff19604c218814037fe90ffc7625a50a/docutils-0.23.tar.gz"
    sha256 "746f5060322511280a1e50eb76846ed6bf2342984b2ac04dc42caa1a8d78799e"
  end

  resource "feedgenerator" do
    url "https://files.pythonhosted.org/packages/b0/d2/f05e9f4628cb0df988de66f8a97dd52877490e6ebf8e7b41cd341bf2ad6b/feedgenerator-2.2.1.tar.gz"
    sha256 "0eaa955f1f0bcb5b87ac195af740f06ff9fff4a40ed30b8a7c6bbebb264d4dd1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/29/6f/da4c6aea59b3001f2e8c0ec7497475aadaf3b021c10cab5b2858f0f32b26/markdown-3.10.3.tar.gz"
    sha256 "3589362618f743188b4d955b874402bc814f4f83f544dc207719f4baa7d9c45f"
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

  resource "ordered-set" do
    url "https://files.pythonhosted.org/packages/4c/ca/bfac8bc689799bcca4157e0e0ced07e70ce125193fc2e166d2e685b7e2fe/ordered-set-4.1.0.tar.gz"
    sha256 "694a8e44c87657c59292ede72891eb91d34131f6531463aab3009191c77364a8"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "unidecode" do
    url "https://files.pythonhosted.org/packages/94/7d/a8a765761bbc0c836e397a2e48d498305a865b70a8600fd7a942e85dcf63/Unidecode-1.4.0.tar.gz"
    sha256 "ce35985008338b676573023acc382d62c264f307c8f7963733405add37ea2b23"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/cd/41/5e1a4bb12aac5f1493fa1bdc11154eca3b258ca4eba65d39c473fe19d8e9/watchfiles-1.2.0.tar.gz"
    sha256 "c995fba777f1ea992f090f9236e9284cf7a5d1a0130dd5a3d82c598cacd76838"
  end

  def install
    virtualenv_install_with_resources
    # Remove ARM binaries on Intel macOS
    rm_r libexec.glob("lib/python*.*/site-packages/pelican/build/aarch64-*") if OS.mac? && Hardware::CPU.intel?
  end

  test do
    (testpath/"content/test-article.md").write <<~MARKDOWN
      Title: Test Article
      Date: #{Time.now}
      Category: Test

      This is a test article
    MARKDOWN

    system bin/"pelican"
    assert_path_exists "output/test-article.html"
  end
end

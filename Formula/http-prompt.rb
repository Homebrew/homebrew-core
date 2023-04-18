class HttpPrompt < Formula
  include Language::Python::Virtualenv

  desc "Interactive command-line HTTP client with autocomplete and syntax highlighting"
  homepage "https://http-prompt.com"
  url "https://files.pythonhosted.org/packages/bf/e2/bc5b0df107afcac65fde7015df48cbe9b4d877d1d0818203544ed1a41d4c/http-prompt-2.1.0.tar.gz"
  sha256 "eee71a00fed0b8a2a35bb338b269be7a20e8a1a6f6465a65561d76a21521e7f3"
  license "MIT"
  revision 1
  head "https://github.com/httpie/http-prompt.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5849569ef0bc11192d89de3258b724a27a7eaa46648d196e90b3c8eb1eea532c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0e1f8b0bb77bf8fce5ac1e05ced804fcd8948dc08469ea90dcd208c1fd8fc42"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "045b57683a7a2f12769b6be9b365792d69912c51673d37eb9f4122371b632e6e"
    sha256 cellar: :any_skip_relocation, ventura:        "c58cfd99a536f9512a33aae19be3311b6e31de7162580c969a33c66a4cef1220"
    sha256 cellar: :any_skip_relocation, monterey:       "73102747d9cc22242d24a21b03b261c9063a7f9b45488b6ad1f7060e3ffa3ada"
    sha256 cellar: :any_skip_relocation, big_sur:        "88b32e77b0593911a1d6e0c84ae568c2406904a5e8833b0716dd1f8d10a57762"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4eb5cd29dfe444fdd51573ab06b712988acbfcf7aa66f53eda8d0ec78790202d"
  end

  depends_on "pygments"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/96/d7/1675d9089a1f4677df5eb29c3f8b064aa1e70c1251a0a8a127803158942d/charset-normalizer-3.0.1.tar.gz"
    sha256 "ebea339af930f8ca5d7a699b921106c6e29c617fe9606fa7baa043c1cdae326f"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "httpie" do
    url "https://files.pythonhosted.org/packages/e9/38/e94dac67b61f4dab49c1d26dd47e0b13be8c69c8c1c4fad5a4a87de1d647/httpie-3.2.1.tar.gz"
    sha256 "c9c0032ca3a8d62492b7231b2dd83d94becf3b71baf8a4bbcd9ed1038537e3ec"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/33/e9/ac8a93e9eda3891ecdfecf5e01c060bbd2c44d4e3e77efc83b9c7ce9db32/markdown-it-py-2.1.0.tar.gz"
    sha256 "cf7e59fed14b5ae17c0006eff14a2d9a00ed5f3a846148153899a0224e2c07da"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/4a/15/bd620f7a6eb9aa5112c4ef93e7031bcd071e0611763d8e17706ef8ba65e0/multidict-6.0.4.tar.gz"
    sha256 "3666906492efb76453c0e7b97f2cf459b0682e7402c0489a95484965dbc1da49"
  end

  resource "parsimonious" do
    url "https://files.pythonhosted.org/packages/7b/91/abdc50c4ef06fdf8d047f60ee777ca9b2a7885e1a9cea81343fbecda52d7/parsimonious-0.10.0.tar.gz"
    sha256 "8281600da180ec8ae35427a4ab4f7b82bfec1e3d1e52f80cb60ea82b9512501c"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/c5/64/c170e5b1913b540bf0c8ab7676b21fdd1d25b65ddeb10025c6ca43cccd4c/prompt_toolkit-1.0.18.tar.gz"
    sha256 "dd4fca02c8069497ad931a2d09914c6b0d1b50151ce876bc15bde4c747090126"
  end

  resource "PySocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/27/b5/92d404279fd5f4f0a17235211bb0f5ae7a0d9afb7f439086ec247441ed28/regex-2022.10.31.tar.gz"
    sha256 "a3a98921da9a1bf8457aeee6a551948a83601689e5ecdd736894ea9bbec77e83"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/0c/4c/07f01c6ac44f7784fa399137fbc8d0cdc1b5d35304e8c0f278ad82105b58/requests-toolbelt-0.10.1.tar.gz"
    sha256 "62e09f7ff5ccbda92772a29f394a49c3ad6cb181d568b1337626b2abb628a63d"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/68/31/b8934896818c885001aeb7df388ba0523ea3ec88ad31805983d9b0480a50/rich-13.3.1.tar.gz"
    sha256 "125d96d20c92b946b983d0d392b84ff945461e5a06d3867e9f9e575f8697b67f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/5e/5f/1e4bd82a9cc1f17b2c2361a2d876d4c38973a997003ba5eb400e8a932b6c/wcwidth-0.2.6.tar.gz"
    sha256 "a5220780a404dbe3353789870978e472cfe477761f06ee55077256e509b156d0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    require "pty"
    require "expect"

    test_url = "http://brew.sh"

    PTY.spawn(bin/"http-prompt", test_url) do |read, write, _pid|
      read.expect(/#{test_url}> /)
      write.puts "get > test.html"
      read.expect(/#{test_url}> /)
      write.puts "exit"
      read.expect(/Goodbye!/)
    end

    assert File.read("test.html").start_with? "<html>"
  end
end

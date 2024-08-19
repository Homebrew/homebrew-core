class Iredis < Formula
  include Language::Python::Virtualenv

  desc "Terminal Client for Redis with AutoCompletion and Syntax Highlighting"
  homepage "https://iredis.xbin.io/"
  url "https://files.pythonhosted.org/packages/7a/80/ac86d397fa0b931cfa0121ed23549a245e706b4b34e4bfc491bcd4123acf/iredis-1.15.0.tar.gz"
  sha256 "70c3c3d260c1f1a49145b3242a054ae1a5142021d49c72c199760874ab2c069c"
  license "BSD-3-Clause"
  head "https://github.com/laixintao/iredis.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d30f9e8ea40f326932c1e37082366a595dc8ef317af746260987477ee01af756"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d30f9e8ea40f326932c1e37082366a595dc8ef317af746260987477ee01af756"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d30f9e8ea40f326932c1e37082366a595dc8ef317af746260987477ee01af756"
    sha256 cellar: :any_skip_relocation, sonoma:         "d30f9e8ea40f326932c1e37082366a595dc8ef317af746260987477ee01af756"
    sha256 cellar: :any_skip_relocation, ventura:        "d30f9e8ea40f326932c1e37082366a595dc8ef317af746260987477ee01af756"
    sha256 cellar: :any_skip_relocation, monterey:       "d30f9e8ea40f326932c1e37082366a595dc8ef317af746260987477ee01af756"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f3d0c7ef651d8a7197611927049062a54c0c39b44f71402cdd1c2f12c6d6d92"
  end

  depends_on "python@3.12"

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "mistune" do
    url "https://files.pythonhosted.org/packages/ef/c8/f0173fe3bf85fd891aee2e7bcd8207dfe26c2c683d727c5a6cc3aec7b628/mistune-3.0.2.tar.gz"
    sha256 "fc7f93ded930c92394ef2cb6f04a8aabab4117a91449e72dcc8dfa646a508be8"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/cc/c6/25b6a3d5cd295304de1e32c9edbcf319a52e965b339629d37d42bb7126ca/prompt_toolkit-3.0.43.tar.gz"
    sha256 "3527b7af26106cbc65a040bcc84839a3566ec1b051bb0bfe953631e704b0ff7d"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/55/59/8bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565/pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "redis" do
    url "https://files.pythonhosted.org/packages/eb/fc/8e822fd1e0a023c5ff80ca8c469b1d854c905ebb526ba38a90e7487c9897/redis-5.0.3.tar.gz"
    sha256 "4973bae7444c0fbed64a06b87446f79361cb7e4ec1538c022d696ed7a5015580"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/25/9d/0acbed6e4a4be4fc99148f275488580968f44ddb5e69b8ceb53fc9df55a0/wcwidth-0.1.9.tar.gz"
    sha256 "ee73862862a156bf77ff92b09034fc4825dd3af9cf81bc5b360668d425f3c5f1"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    port = free_port
    output = shell_output("#{bin}/iredis -p #{port} info 2>&1", 1)
    assert_match "Connection refused", output
  end
end

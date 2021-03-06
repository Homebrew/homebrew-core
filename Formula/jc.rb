class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/f3/51/25e8eb139cc60a3dbdd4ff2d2befe2400055616e5bf04b8d3e2208c8f218/jc-1.14.4.tar.gz"
  sha256 "562370981da44eba8916647c6947456eb811c803407106d3f47a302205fcc396"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "96c3888568a2789546a3be8562b2306597f35e0b9919cecc1476b9ff07c17925"
    sha256 cellar: :any_skip_relocation, big_sur:       "2cd733c855d652097873d6a91e462171cdae1c14530454b1ffe4ff37ce82fb13"
    sha256 cellar: :any_skip_relocation, catalina:      "b1a2fe86d7cb212534015437d94bc137774e4bf89fc260886095afaa5ad80d9d"
    sha256 cellar: :any_skip_relocation, mojave:        "2f76c0e5dd7e88fd5c5c9fda8a5e216612d7c99277e5c89c0097f6c6711bf530"
  end

  depends_on "python@3.9"

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/19/d0/dec5604a275b19b0ebd2b9c43730ce39549c8cd8602043eaf40c541a7256/Pygments-2.8.0.tar.gz"
    sha256 "37a13ba168a02ac54cc5891a42b1caec333e59b66addb7fa633ea8a6d73445c0"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/1d/2f/40abf6501e051df8af970bfa6d81a90fcd62dc536f82ceec80a2694a3123/ruamel.yaml-0.16.13.tar.gz"
    sha256 "bb48c514222702878759a05af96f4b7ecdba9b33cd4efcf25c86b882cef3a942"
  end

  resource "ruamel.yaml.clib" do
    url "https://files.pythonhosted.org/packages/fa/a1/f9c009a633fce3609e314294c7963abe64934d972abea257dce16a15666f/ruamel.yaml.clib-0.2.2.tar.gz"
    sha256 "2d24bd98af676f4990c4d715bcdc2a60b19c56a3fb3a763164d2d8ca0e806ba7"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/58/40/0d783e14112e064127063fbf5d1fe1351723e5dfe9d6daad346a305f6c49/xmltodict-0.12.0.tar.gz"
    sha256 "50d8c638ed7ecb88d90561beedbf720c9b4e851a9fa6c47ebd64e99d166d8a21"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "[{\"header1\": \"data1\", \"header2\": \"data2\"}]\n", \
                  pipe_output("#{bin}/jc --csv", "header1, header2\n data1, data2")
  end
end

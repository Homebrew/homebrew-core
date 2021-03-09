class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/f3/51/25e8eb139cc60a3dbdd4ff2d2befe2400055616e5bf04b8d3e2208c8f218/jc-1.14.4.tar.gz"
  sha256 "562370981da44eba8916647c6947456eb811c803407106d3f47a302205fcc396"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6cd54ccce5655d227ba7846bd8ed674042dd19fe910c27362e976a2ecc679217"
    sha256 cellar: :any_skip_relocation, big_sur:       "4ef5f2529d82171c2cd4a0ec195865e743f0a8f4e91b0941f0941879989c436b"
    sha256 cellar: :any_skip_relocation, catalina:      "89ec124861ca6f52f38714398a8e9d4ab998cedcda891daa73ee0ecf28961640"
    sha256 cellar: :any_skip_relocation, mojave:        "2471bc5e4c2bed3477644d6259b1ba234724b94258019e83029a7c88b9fa0af1"
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

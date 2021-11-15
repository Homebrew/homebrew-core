class Pywhat < Formula
  include Language::Python::Virtualenv

  desc "🐸 Identify anything: emails, IP addresses, and more 🧙"
  homepage "https://github.com/bee-san/pyWhat"
  url "https://files.pythonhosted.org/packages/2a/fe/bcc4a456b49980791c2522ccb07c4d58258a38221018e1d989a6ac2da130/pywhat-5.0.0.tar.gz"
  sha256 "03a47951ee0bc50c2d55fafd6693a54c4dd1f8dce834ea6587b0305ec3d3059e"
  license "MIT"
  head "https://github.com/bee-san/pyWhat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d41a324b9fb081caeb2f00123dfc792ab6fa1e9c5bb0dfbb5217ecca08461494"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "922f5c671360e9194d6db373c66b4dbee61ea0808146a8d19a51b085fc7e6916"
    sha256 cellar: :any_skip_relocation, monterey:       "39f643dee920b765eef26aa0c48a712698321bf3506b51575ac8a156a005be91"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d05863a537b8c854d38cb45d3d9b7b3463e1268cc5ceba9f25e8437b58dac2f"
    sha256 cellar: :any_skip_relocation, catalina:       "e8b46ef709fb70dad845cd57abbbc56603c23108de4a459485792b62fedb1ec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0097a14d0dfedd15ad7fa2a156080dbe69975b207211a658153f33639c0ef236"
  end

  depends_on "python@3.9"
  depends_on "six"

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b7/b3/5cba26637fe43500d4568d0ee7b7362de1fb29c0e158d50b4b69e9a40422/Pygments-2.10.0.tar.gz"
    sha256 "f398865f7eb6874156579fdf36bc840a03cab64d1cde9e93d68f46a425ec52c6"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/4e/fd/5d40b0363467f8c87d5f5f551b7b431e234bff2becf959daab453f9d7795/rich-10.12.0.tar.gz"
    sha256 "83fb3eff778beec3c55201455c17cccde1ccdf66d5b4dade8ef28f56b50c4bd4"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Internet Protocol (IP)", shell_output("#{bin}/pywhat 127.0.0.1").strip
  end
end

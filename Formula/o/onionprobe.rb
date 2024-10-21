class Onionprobe < Formula
  include Language::Python::Virtualenv

  desc "Test and monitoring tool for Tor Onion Services"
  homepage "https://tpo.pages.torproject.net/onion-services/onionprobe/"
  url "https://files.pythonhosted.org/packages/aa/a7/881b66594477795314e4a5029f098eb78cf21c843b63bed8d3c7cfcf5fe4/onionprobe-1.2.0.tar.gz"
  sha256 "65ef77047e2cb24de999dcfeeb759de04f6ec952612a5aa9225dc92488696dc5"
  license "GPL-3.0-or-later"
  revision 2
  head "https://gitlab.torproject.org/tpo/onion-services/onionprobe.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "3e82006a15ea00cd837933aaa31251ff103abfd778f8ebbbef9bce49ff4bde72"
    sha256 cellar: :any,                 arm64_sonoma:  "cd6b2b66dfbc2a38791fa61a0f546844ad53e13d70e926424852ba60e3b98c12"
    sha256 cellar: :any,                 arm64_ventura: "3a17b6ab40162a561db3a94e2ed8ee52368bf0f30e5e63fa90d17cabbfb8fc26"
    sha256 cellar: :any,                 sonoma:        "5371c35e61dfae1384a4d370fd812e6dd9fd6a222b9ce31523a2c2281efbc338"
    sha256 cellar: :any,                 ventura:       "cf1c2a0eb660c5af658a9193251bc33ae386538914cd45d96314a0978f0c0669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77527d81a1f281d219577cc01bcc4f31a87f67466cf743ad2decdfb9f74e1019"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13"
  depends_on "tor"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "prometheus-client" do
    url "https://files.pythonhosted.org/packages/e1/54/a369868ed7a7f1ea5163030f4fc07d85d22d7a1d270560dab675188fb612/prometheus_client-0.21.0.tar.gz"
    sha256 "96c83c606b71ff2b0a433c98889d275f51ffec6c5e267de37c7a2b5c9aa9233e"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "stem" do
    url "https://files.pythonhosted.org/packages/94/c6/b2258155546f966744e78b9862f62bd2b8671b422bb9951a1330e4c8fd73/stem-1.8.2.tar.gz"
    sha256 "83fb19ffd4c9f82207c006051480389f80af221a7e4783000aedec4e384eb582"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/onionprobe --version")

    output = shell_output("#{bin}/onionprobe -e 2gzyxa5ihm7nsggfxnu52rck2vv4rvmdlkiu3zzui5du4xyclen53wid.onion 2>&1")
    assert_match "Status code is 200", output
  end
end

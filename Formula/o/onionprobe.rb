class Onionprobe < Formula
  include Language::Python::Virtualenv

  desc "Test and monitoring tool for Tor Onion Services"
  homepage "https://tpo.pages.torproject.net/onion-services/onionprobe/"
  url "https://files.pythonhosted.org/packages/17/7c/e016a43640336dd392cd7abcac375341b499f95cf6ebc92ce5eda5e4845f/onionprobe-1.3.0.tar.gz"
  sha256 "3024e0c737e38f4b9dce265d9e2bd7ef03879c46b2cd40c336a5161eb0affbd7"
  license "GPL-3.0-or-later"
  head "https://gitlab.torproject.org/tpo/onion-services/onionprobe.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9222f214b1620a345e9cf321b087dcc34542a7a98c74ff46555c3a9b52dd1a30"
    sha256 cellar: :any,                 arm64_sonoma:  "2b5d468661d595f8f431d6e7ea60d7b39354a914c0b4573c432d2d6d36477fe8"
    sha256 cellar: :any,                 arm64_ventura: "0a14c6c6d81752053ab04199df5e67e1749939bc39fb6df43890ebd325f37d60"
    sha256 cellar: :any,                 sonoma:        "3a77783777dce8d656a6003f0cb8efd4df8cf9a93d45579b563a631bcb4da4c2"
    sha256 cellar: :any,                 ventura:       "8afcf6e56779767135cd9b45a7d968d22d6a98e409c9ff29a747a4feb88dcb1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69261fbf674c9daa3cdecab548a8d20de52e6dc1e71945cb9d10fa2beaa43a80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38203b9e39cfecb4d59d439bc6f8f79f1df32e78532cb42297f215b223a3669f"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13"
  depends_on "tor"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/16/b0/572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357/charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "prometheus-client" do
    url "https://files.pythonhosted.org/packages/62/14/7d0f567991f3a9af8d1cd4f619040c93b68f09a02b6d0b6ab1b2d1ded5fe/prometheus_client-0.21.1.tar.gz"
    sha256 "252505a722ac04b0456be05c05f75f45d760c2911ffc45f2a06bcaed9f3ae3fb"
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
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
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

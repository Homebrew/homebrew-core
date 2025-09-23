class Onionprobe < Formula
  include Language::Python::Virtualenv

  desc "Test and monitoring tool for Tor Onion Services"
  homepage "https://tpo.pages.torproject.net/onion-services/onionprobe/"
  url "https://files.pythonhosted.org/packages/54/5c/cd134dc632131ad3e88bae3c28cacf15443fc76541f731c184f171a54e83/onionprobe-1.4.0.tar.gz"
  sha256 "ae3131326d669287918aff9a36e0ba21ea34fd7e6c6ec8ee4a20077274318c5a"
  license "GPL-3.0-or-later"
  head "https://gitlab.torproject.org/tpo/onion-services/onionprobe.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "adb87a0ad58b774185a34ab3650f92006728226bda208440b81d0f5536906c95"
    sha256 cellar: :any,                 arm64_sequoia: "a3b51ab0c45c28282ff0592ff3bd1c9a74ceeda26609cd2f067e9c837e3895f3"
    sha256 cellar: :any,                 arm64_sonoma:  "dbaff55faea244b4f13c96dc1d39f971ba592d9c448a2394e513a988e902742f"
    sha256 cellar: :any,                 arm64_ventura: "fc6f4d6ae60f853bdaed891063d53dd6e1b3ae218498d97a586087fe0712d6ec"
    sha256 cellar: :any,                 sonoma:        "f60ba493290ddeb5a5aa90d233a2d7e81f13b07cb2b5d99d66aadec7c49bc493"
    sha256 cellar: :any,                 ventura:       "3f76341c4c7d240c7084b1c93b0cdf2edd03151acd84902f3ad6fbb406b7697c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc8c2397e8cba048232f2962eef64bc0170c6d876116a9aa17cffab41dfce323"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35fa7574d64bb7d7f1e4982ce041e47ae34e0ec599c3ec8bed32cb22af7f51f5"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13"
  depends_on "tor"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "prometheus-client" do
    url "https://files.pythonhosted.org/packages/5e/cf/40dde0a2be27cc1eb41e333d1a674a74ce8b8b0457269cc640fd42b07cf7/prometheus_client-0.22.1.tar.gz"
    sha256 "190f1331e783cf21eb60bca559354e0a4d4378facecf78f5428c39b675d20d28"
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
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "stem" do
    url "https://files.pythonhosted.org/packages/94/c6/b2258155546f966744e78b9862f62bd2b8671b422bb9951a1330e4c8fd73/stem-1.8.2.tar.gz"
    sha256 "83fb19ffd4c9f82207c006051480389f80af221a7e4783000aedec4e384eb582"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
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

class B4 < Formula
  include Language::Python::Virtualenv

  desc "Tool to work with public-inbox and patch archives"
  homepage "https://b4.docs.kernel.org/en/latest/"
  url "https://files.pythonhosted.org/packages/3b/89/70da0dcb6a75833a388aeb15aef12d859950793f8ce68faff757df97d1e3/b4-0.16.0.tar.gz"
  sha256 "071823a1e904508a6fd9aaf8cc2f9a92697e1dfa270000b4d1130015b56f4137"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "dd072156124bc9c700880f10eb01623d9cc9b3c040712ae113cb53e7eea36a58"
    sha256 cellar: :any, arm64_tahoe:       "c6853f7e1dd8a4ab8f80a129abdde3d4e0f6d1b6b4285d24d39adaa58e7a30cb"
    sha256 cellar: :any, arm64_sequoia:     "38cd88716b99493139c95595682ed5b4d1701e251cdb1f2acd7d25b1756122af"
    sha256 cellar: :any, arm64_linux:       "661b9bc7807292dcbbdf600ecd706a120a9006fee87b7310c1262f5d041fd12e"
    sha256 cellar: :any, x86_64_linux:      "8aa1956af8a553cbbb53909017493e898b654908384fd0bfbf6d0c4095b79ca2"
  end

  depends_on "rust" => :build # for `dnspython`
  depends_on "certifi" => :no_linkage
  depends_on "cffi" => :no_linkage
  depends_on "libgit2"
  depends_on "libsodium"
  depends_on "python@3.15"

  pypi_packages exclude_packages: %w[certifi cffi]

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "dkimpy" do
    url "https://files.pythonhosted.org/packages/f0/6f/84e91828186bbfcedd7f9385ef5e0d369632444195c20e08951b7ffe0481/dkimpy-1.1.8.tar.gz"
    sha256 "b5f60fb47bbf5d8d762f134bcea0c388eba6b498342a682a21f1686545094b77"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/76/49/900383b471c645a3c397f47b3211d1fcecb3a540c98f683494cdf86b33de/dnspython-2.9.2.tar.gz"
    sha256 "8d4d39a513e649d634004ce4d39ade2352efcea472a0247535a5c2d18a9d7ba9"
  end

  resource "ezgb" do
    url "https://files.pythonhosted.org/packages/f3/d7/8c1134b28950ea6d8be91aa172717c6091639c59c5dee8f0d95e10e43cb9/ezgb-0.2.1.tar.gz"
    sha256 "7837ec0606c6c7ad657ab2ccd4295c7f1efaa357b456e7993ff30f454bb7fe4f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "liblore" do
    url "https://files.pythonhosted.org/packages/05/3e/6cfd7bc2a24f263ee4c2b0bdb242da27c8c04a9b6f432cf8c9282175a020/liblore-0.10.1.tar.gz"
    sha256 "37e6d756d810c78351179c1a348361ef2966c1649711c1350ae7217e5497f248"
  end

  resource "patatt" do
    url "https://files.pythonhosted.org/packages/60/84/ce3398941bcb26a5ee12a066a5d2b052bf9211f713d98ed78573b5364fea/patatt-0.8.0.tar.gz"
    sha256 "c226b5e7e449a4981b827c48e2586a928fa45b690af19a3892b9279b334f2551"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/6a/13/f61226355815c93a2aad4f70b0d5a4df54d043a963bc51e81146623424c2/pygit2-1.21.0.tar.gz"
    sha256 "1e987fbef899d1bf12aecc10b33acc917d60266ca114428dfc260df4451a555f"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/d9/9a/4019b524b03a13438637b11538c82781a5eda427394380381af8f04f467a/pynacl-1.6.2.tar.gz"
    sha256 "018494d6d696ae03c7e656e5e74cdfd8ea1326962cc401bcf018f1ed8436811c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/b4 --version")

    assert_match "No thanks necessary.", shell_output("#{bin}/b4 ty 2>&1")
  end
end

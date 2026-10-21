class B4 < Formula
  include Language::Python::Virtualenv

  desc "Tool to work with public-inbox and patch archives"
  homepage "https://b4.docs.kernel.org/en/latest/"
  url "https://files.pythonhosted.org/packages/3b/89/70da0dcb6a75833a388aeb15aef12d859950793f8ce68faff757df97d1e3/b4-0.16.0.tar.gz"
  sha256 "071823a1e904508a6fd9aaf8cc2f9a92697e1dfa270000b4d1130015b56f4137"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "a57ede8fe668caa46a2cc68466cd36fd0e70403b2a10fa05e99286ed028e9772"
    sha256 cellar: :any, arm64_tahoe:       "aa55d006c18c119faa52cc0ad06eb1167ec839b5a26f13a287b96e1952c69d22"
    sha256 cellar: :any, arm64_sequoia:     "62f84a99e4a36dbe85039c44c8ef2c5d95ba00d3db42640c7918966c5905341d"
    sha256 cellar: :any, arm64_linux:       "e30a22bf630d86dde4f0b3203b0627e3eae51e0bb8ec990a1758c782eecf28ff"
    sha256 cellar: :any, x86_64_linux:      "26335f590cbbf9a5cf6873c930a2cea53ebf80dca9edb22dab64af363bad21c0"
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
    url "https://files.pythonhosted.org/packages/ef/4a/50822184bd67cc6493f0fb6a880749158fcd31ab3fa07409acfd91f9fc85/dnspython-2.9.0.tar.gz"
    sha256 "b44dc6b18f07a8b1c56676a19fbfdb5209415b046a9cece286baafa87ff3f7f1"
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
    url "https://files.pythonhosted.org/packages/9c/11/592cc7854795830a7257ab6025a1fc803b58b0e7bf7d31f619bc7288ed4d/pygit2-1.20.1.tar.gz"
    sha256 "36dff84d237f2b8f18b0b146d6e7c3f99a7bce2da98cc4103a14387f53319f95"
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

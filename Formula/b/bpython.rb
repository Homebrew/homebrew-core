class Bpython < Formula
  include Language::Python::Virtualenv

  desc "Fancy interface to the Python interpreter"
  homepage "https://bpython-interpreter.org"
  url "https://files.pythonhosted.org/packages/44/29/cd80e9108a6fc6a925ffb915f8f69198a2bb2388e39167a41d743ac2a8f4/bpython-0.26.tar.gz"
  sha256 "f79083e1e3723be9b49c9994ad1dd3a19ccb4d0d4f9a6f5b3a73bef8bc327433"
  license "MIT"
  revision 7
  head "https://github.com/bpython/bpython.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d834a4dcd3d9224e61586f28096dcd50b7faca39c8f34b25d422894481c119d3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4c840c2926afa45a67ddf1822820c240be6a476e17aeb27e03cba6dfc4a79582"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5ae74737656c5f59fe19db4b42c9d6fbe648a8e0a0ba73858023fd32fb2e1a41"
    sha256 cellar: :any,                 arm64_linux:       "1f3841a1505a96f7cc91e5123910093911b23672172b0367728a2e101eaf7a0c"
    sha256 cellar: :any,                 x86_64_linux:      "65868f11d4d41b45058b22ae22d6718f1c874d1dfc150e6661b1b660af5f6c7f"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.15"

  pypi_packages exclude_packages: "certifi"

  resource "blessed" do
    url "https://files.pythonhosted.org/packages/0c/7d/44d82d953d9bbcac57fe26507ea7ffba65ef1ec8f41f2b58da2fb12ef26c/blessed-1.50.0.tar.gz"
    sha256 "046c9b2a5283a9c5bc340ed23b7d1c1f10ef2d7fb30b14bae13ef7ffc1f3ba56"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "curtsies" do
    url "https://files.pythonhosted.org/packages/d1/18/5741cb42624089a815520d5b65c39c3e59673a77fd1fab6ad65bdebf2f91/curtsies-0.4.3.tar.gz"
    sha256 "102a0ffbf952124f1be222fd6989da4ec7cce04e49f613009e5f54ad37618825"
  end

  resource "cwcwidth" do
    url "https://files.pythonhosted.org/packages/86/5f/f5c3d1b4e9c8c541406ca0654efa1bfaa05414f8e7d1c14bc6e3fd0752f8/cwcwidth-0.1.12.tar.gz"
    sha256 "bfc16531d1246dd2558eb9b3a63aa37a9978672b956860dc5426da2343ebf366"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/3e/6e/0091f175ccd02b02bc8811bbcbcc6ac2e980be116e3b2f7a736ca322bf84/greenlet-3.5.6.tar.gz"
    sha256 "8e67c43bdfc88d5fee6db0d3e40175b362fc95fb85f0412d233b9b203c53a575"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "jinxed" do
    url "https://files.pythonhosted.org/packages/39/d7/6e6d474ec5eaeca6a61acc17766bb19563b3a372b4b9d92910078f5fe49f/jinxed-2.1.0.tar.gz"
    sha256 "7e755b831faa2443d44fb4ce7c0202eb9c3ed39bd5bf1193365888f4f6092b54"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/f0/b4/7830542634bb2d3e62aa3b586a72d5b3b6c91c3168929e7000ef3fed041d/wcwidth-0.9.2.tar.gz"
    sha256 "ae0ef90b90f6af38b54f1fe6d58662ec33b3cb4b8391958a62416d654231727b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write "print(2+2)\n"
    assert_equal "4\n", shell_output("#{bin}/bpython test.py")
  end
end

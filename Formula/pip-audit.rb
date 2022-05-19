class PipAudit < Formula
  include Language::Python::Virtualenv

  desc "Audits Python environments and dependency trees for known vulnerabilities"
  homepage "https://pypi.org/project/pip-audit/"
  url "https://files.pythonhosted.org/packages/a9/e1/77e3b8dd2c04fb0bc04c3d836eec868283e289ffeeb18d70d6c10431e9b6/pip_audit-2.3.0.tar.gz"
  sha256 "95326d536eab1f60df0c36193675c2ab0777de3ef1b3af98ebfc378159b0bed5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbae659a48513274042b573d3c8edae46e6f565f87abac176bec586f526f4444"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b62cd8a32629a6c210d1de2f28008909b9b194c5963b6e2bb0aaf6af308a28c"
    sha256 cellar: :any_skip_relocation, monterey:       "19b6430042560690ce60f43db10456c85d9a55f02a399a7af8413602de75806a"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d8f0f94491fe1de3ddec81379f99b43a284d4c48ec580aaa0aabfbe6e6f73e9"
    sha256 cellar: :any_skip_relocation, catalina:       "46015384ea64d1650249b6c85eb27239406cbd667b0a5e932a2b4d672001f662"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7b6d0f74a77ee9b56906a3b2fb5014e4922601dece9db0c814d62629efc10f8"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "CacheControl" do
    url "https://files.pythonhosted.org/packages/46/9b/34215200b0c2b2229d7be45c1436ca0e8cad3b10de42cfea96983bd70248/CacheControl-0.12.11.tar.gz"
    sha256 "a5b9fcc986b184db101aa280b42ecdcdfc524892596f606858e0b7a8b4d9e144"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/c5/63/a8e4b0c24e8538cec5579edbb2df4ed1f980d5f186878905317139d83b61/certifi-2022.5.18.tar.gz"
    sha256 "6ae10321df3e464305a46e997da41ea56c1d311fb9ff1dd4e04d6f14653ec63a"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/56/31/7bcaf657fafb3c6db8c787a865434290b726653c912085fbd371e9b92e1c/charset-normalizer-2.0.12.tar.gz"
    sha256 "2857e29ff0d34db842cd7ca3230549d1a697f96ee6d3fb071cfa6c7393832597"
  end

  resource "cyclonedx-python-lib" do
    url "https://files.pythonhosted.org/packages/d6/99/cb03356e010d98c1e52465f9726dea0c77e95180f8b3f3dd3c412141423b/cyclonedx-python-lib-2.4.0.tar.gz"
    sha256 "35ef1dbff4aab8ef143552cecde4ef9050f805957519339991e488f80cab36e2"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "lockfile" do
    url "https://files.pythonhosted.org/packages/17/47/72cb04a58a35ec495f96984dddb48232b551aafb95bde614605b754fe6f7/lockfile-0.12.2.tar.gz"
    sha256 "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/61/3c/2206f39880d38ca7ad8ac1b28d2d5ca81632d163b2d68ef90e46409ca057/msgpack-1.0.3.tar.gz"
    sha256 "51fdc7fb93615286428ee7758cecc2f374d5ff363bdd884c7ea622a7a327a81e"
  end

  resource "packageurl-python" do
    url "https://files.pythonhosted.org/packages/6e/ee/8d89d660da6e44d77f547de9949b380dc93b08b758ee361bc237bcc8b179/packageurl-python-0.9.9.tar.gz"
    sha256 "872a0434b9a448b3fa97571711f69dd2a3fb72345ad66c90b17d827afea82f09"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pip-api" do
    url "https://files.pythonhosted.org/packages/f6/a2/1a9eb1afc8509282aacf2609d073f54509c8370cac6ae1551a37efc2f2bb/pip-api-0.0.29.tar.gz"
    sha256 "f701584eb1c3e01021c846f89d629ab9373b6624f0626757774ad54fc4c29571"
  end

  resource "progress" do
    url "https://files.pythonhosted.org/packages/2a/68/d8412d1e0d70edf9791cbac5426dc859f4649afc22f2abbeb0d947cf70fd/progress-1.6.tar.gz"
    sha256 "c9c86e98b5c03fa1fe11e3b67c1feda4788b8d0fe7336c2ff7d5644ccfba34cd"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
  end

  resource "resolvelib" do
    url "https://files.pythonhosted.org/packages/ac/20/9541749d77aebf66dd92e2b803f38a50e3a5c76e7876f45eb2b37e758d82/resolvelib-0.8.1.tar.gz"
    sha256 "c6ea56732e9fb6fca1b2acc2ccc68a0b6b8c566d8f3e78e0443310ede61dbd37"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "types-setuptools" do
    url "https://files.pythonhosted.org/packages/42/2e/d21d995feca499eac401958fee97879926249e60b8e5608f0361f0ee2ae1/types-setuptools-57.4.14.tar.gz"
    sha256 "df02fe1dd244f58cf4e67cfc3d0a97930a2d61a72dd89f21d81c71017cd83f9a"
  end

  resource "types-toml" do
    url "https://files.pythonhosted.org/packages/c5/da/a5fb5c4eb663a1cd2d0c8ef619c42d51e6b8f55e155341e7b39b8c6c67b4/types-toml-0.10.7.tar.gz"
    sha256 "a567fe2614b177d537ad99a661adc9bfc8c55a46f95e66370a4ed2dd171335f9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1b/a5/4eab74853625505725cefdf168f48661b2cd04e7843ab836f3f63abf81da/urllib3-1.26.9.tar.gz"
    sha256 "aabaf16477806a5e1dd19aa41f8c2b7950dd3c746362d7e3223dbe6de6ac448e"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "No known vulnerabilities found", shell_output("#{bin}/pip-audit --progress-spinner=off 2>&1")
  end
end

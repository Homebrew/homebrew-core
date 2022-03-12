class PipAudit < Formula
  include Language::Python::Virtualenv

  desc "Audits Python environments and dependency trees for known vulnerabilities"
  homepage "https://pypi.org/project/pip-audit/"
  url "https://files.pythonhosted.org/packages/c3/1f/d1ee4015c2e32d0d198b10ae0558d506b7af09df98c25fd7b4b716a641a4/pip-audit-2.1.0.tar.gz"
  sha256 "b987aa4c6b31e316db197d370443ff34053ca0400a27f7407e74a71d92006a89"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "393b7b72985c2c8f78f042913c40e6314085b7281e3843f58924218cf0be2fac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9710aae8f590cf8e745d664888d3caa687d71b79b802e029f12dc40cafbd7371"
    sha256 cellar: :any_skip_relocation, monterey:       "5c8ebab50f0fdf302e795134fec56310bcf02242660c7e8a832aa9067b4ccc57"
    sha256 cellar: :any_skip_relocation, big_sur:        "590ca7d154faee6b5320c750ee62f9fcbfe1076046dcdef956699392094d6cbd"
    sha256 cellar: :any_skip_relocation, catalina:       "48822398d81c37e958fb82c031a95eba7bc01546aa27097b172694e29a571a80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "403fe1a4f7c3188737bd35c9122e458cf9d14acb184688d6043ffd49a5935612"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "CacheControl" do
    url "https://files.pythonhosted.org/packages/d0/74/3748ee1144234a525d84c4905002a5f39795d265bcdecca74142a8df5206/CacheControl-0.12.10.tar.gz"
    sha256 "d8aca75b82eec92d84b5d6eb8c8f66ea16f09d2adb09dbca27fe2d5fc8d3732d"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/56/31/7bcaf657fafb3c6db8c787a865434290b726653c912085fbd371e9b92e1c/charset-normalizer-2.0.12.tar.gz"
    sha256 "2857e29ff0d34db842cd7ca3230549d1a697f96ee6d3fb071cfa6c7393832597"
  end

  resource "cyclonedx-python-lib" do
    url "https://files.pythonhosted.org/packages/46/9e/b74de8ca49f622a2ed2c16b0340dd502a1be66c75f60063c1a0f016e2405/cyclonedx-python-lib-2.0.0.tar.gz"
    sha256 "32d6f3372b69df5734373a698cce81ffeed65d882a1a9c48891914cb0658279e"
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
    url "https://files.pythonhosted.org/packages/d6/60/9bed18f43275b34198eb9720d4c1238c68b3755620d20df0afd89424d32b/pyparsing-3.0.7.tar.gz"
    sha256 "18ee9022775d270c55187733956460083db60b37d0d0fb357445f3094eed3eea"
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
    url "https://files.pythonhosted.org/packages/b5/c3/14b741883488161ad09b8a99322c4935f18ec9d44e1e17541d2f5a3a27bd/types-setuptools-57.4.10.tar.gz"
    sha256 "9a13513679c640f6616e2d9ab50d431c99ca8ae9848a97243f887c80fd5cf294"
  end

  resource "types-toml" do
    url "https://files.pythonhosted.org/packages/da/ea/2390796052b1608580ee483d7e8a7e345dd01d9a4149cb45d9467be6b8c0/types-toml-0.10.4.tar.gz"
    sha256 "9340e7c1587715581bb13905b3af30b79fe68afaccfca377665d5e63b694129a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b0/b1/7bbf5181f8e3258efae31702f5eab87d8a74a72a0aa78bc8c08c1466e243/urllib3-1.26.8.tar.gz"
    sha256 "0e7c33d9a63e7ddfcb86780aac87befc2fbddf46c58dbb487e0855f7ceec283c"
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

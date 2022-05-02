class PipAudit < Formula
  include Language::Python::Virtualenv

  desc "Audits Python environments and dependency trees for known vulnerabilities"
  homepage "https://pypi.org/project/pip-audit/"
  url "https://files.pythonhosted.org/packages/98/d9/3648bf6562a08ccbc63d00d242eb0333357df05f0f64f11bb26e7e2478a4/pip-audit-2.2.1.tar.gz"
  sha256 "81825477c86fb5a6458d700ff6dfee0fd3a6d3e2e63ff365e4da4475d0f00bff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4062499c15252e57a69b33e939bea04c3bd56c34f1e08ad902e684b0264aca4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "771ff8ee32d6e6afa3e1f6fd4c83b450b444c9c6cbc93c955897fe6f38519d02"
    sha256 cellar: :any_skip_relocation, monterey:       "51dae062caf0f115c5940e018f0f1329adbaf59b16166e84b3a926f8e5bc9b99"
    sha256 cellar: :any_skip_relocation, big_sur:        "2af3cd9ca3d2d5895b3afb30d28f91db4a7eaf1357689c97f9f6acbac52c04be"
    sha256 cellar: :any_skip_relocation, catalina:       "e1e1d016dde4f8042e47f3b9e6cbce6633caa3ab0137fa5516bf1fef9e28092e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b32c1aee4e5f33dbf632af572f93790cf91285d51a8c0be884003314c5942f8d"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "CacheControl" do
    url "https://files.pythonhosted.org/packages/46/9b/34215200b0c2b2229d7be45c1436ca0e8cad3b10de42cfea96983bd70248/CacheControl-0.12.11.tar.gz"
    sha256 "a5b9fcc986b184db101aa280b42ecdcdfc524892596f606858e0b7a8b4d9e144"
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
    url "https://files.pythonhosted.org/packages/aa/82/19976dd4decc2fca8b1801fe12f13f945f1dae32281d8cc7c67ddc3a3d50/cyclonedx-python-lib-2.3.0.tar.gz"
    sha256 "85b497202f5aa56349fe0c916f5759a363d78214b244ad658f6980233049700b"
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
    url "https://files.pythonhosted.org/packages/31/df/789bd0556e65cf931a5b87b603fcf02f79ff04d5379f3063588faaf9c1e4/pyparsing-3.0.8.tar.gz"
    sha256 "7bf433498c016c4314268d95df76c81b842a4cb2b276fa3312cfb1e1d85f6954"
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
    url "https://files.pythonhosted.org/packages/1e/60/1c41ead493d2735b8a9c928c7c30ede3e30c4aed9a1ae053aaa32a978b78/types-toml-0.10.6.tar.gz"
    sha256 "6aeb3ed7bfa869381551c774ed6a9142e3eed98a83efa5108a9632eafd56dcd3"
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

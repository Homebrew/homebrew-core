class PipAudit < Formula
  include Language::Python::Virtualenv

  desc "Audits Python environments and dependency trees for known vulnerabilities"
  homepage "https://pypi.org/project/pip-audit/"
  url "https://files.pythonhosted.org/packages/43/40/48a9082815a2963380f7a8b00a9f2a25f354d89cb22489f1df65fba83de5/pip_audit-2.4.15.tar.gz"
  sha256 "aeb55541c897802d0a25510d723630d1155d91579bb8dba9b0d5e5e8a01595dd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97827d5f5b654449be6e52a6a9734a835a7aeacb7a3ad465229b63c30f74e48e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fba234ac60cb337a18d94a43f8c07385e271dfbd8e5707db236a47fe7f4594f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bfe8447e5e1f4181de4719c43949a3b54b8a10768b156bdb37348e7abff643c5"
    sha256 cellar: :any_skip_relocation, ventura:        "34239e633228cfd016d04220d8d04e335c5d1948dca800dfae0786f1421c5efd"
    sha256 cellar: :any_skip_relocation, monterey:       "24987742da9e151133384de49389016ba610cc08e6a4ca99cac386b3aed7f508"
    sha256 cellar: :any_skip_relocation, big_sur:        "de6160eca1da2e6ab6fcbaf5674b6824efcfefa2fc55c0961b25848ebd7be11e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1eac671aec56067f6794e7c25833af3333c31e408c8ea7b8af75e9551cf0e4d7"
  end

  depends_on "pygments"
  depends_on "python@3.11"
  depends_on "six"

  resource "CacheControl" do
    url "https://files.pythonhosted.org/packages/06/80/1f8ba1ced5f29514d8621003b2b0fb404ed88996e963dbca7f519ecc82ca/CacheControl-0.12.12.tar.gz"
    sha256 "9c2e5208ea76ebd9921176569743ddf6d7f3bb4188dbf61806f0f8fc48ecad38"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/96/d7/1675d9089a1f4677df5eb29c3f8b064aa1e70c1251a0a8a127803158942d/charset-normalizer-3.0.1.tar.gz"
    sha256 "ebea339af930f8ca5d7a699b921106c6e29c617fe9606fa7baa043c1cdae326f"
  end

  resource "cyclonedx-python-lib" do
    url "https://files.pythonhosted.org/packages/dd/0d/2d77978ff3ebe445c00ffc209eb205d126ef7a8ece69e7f3d014e561bada/cyclonedx_python_lib-3.1.5.tar.gz"
    sha256 "1ccd482024a30b95c4fffb3fe567a9df97b705f34c1075f8abde8537867600c3"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/0b/dc/eac02350f06c6ed78a655ceb04047df01b02c6b7ea3fc02d4df24ca87d24/filelock-3.9.0.tar.gz"
    sha256 "7b319f24340b51f55a2bf7a12ac0755a9b03e718311dac567a0f4f7fabd2f5de"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/33/e9/ac8a93e9eda3891ecdfecf5e01c060bbd2c44d4e3e77efc83b9c7ce9db32/markdown-it-py-2.1.0.tar.gz"
    sha256 "cf7e59fed14b5ae17c0006eff14a2d9a00ed5f3a846148153899a0224e2c07da"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/22/44/0829b19ac243211d1d2bd759999aa92196c546518b0be91de9cacc98122a/msgpack-1.0.4.tar.gz"
    sha256 "f5d869c18f030202eb412f08b28d2afeea553d6613aee89e200d7aca7ef01f5f"
  end

  resource "packageurl-python" do
    url "https://files.pythonhosted.org/packages/59/ee/1e22fde9f8210b1bad0ada2a629d0e0c145627f546f793f0e5237109fe86/packageurl-python-0.10.4.tar.gz"
    sha256 "5c91334f942cd55d45eb0c67dd339a535ef90e25f05b9ec016ad188ed0ef9048"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "pip-api" do
    url "https://files.pythonhosted.org/packages/69/a2/90dd01b87277ae65a6fb725dae86a039aeb34e24f576600abd0434aa95c4/pip-api-0.0.30.tar.gz"
    sha256 "a05df2c7aa9b7157374bcf4273544201a0c7bae60a9c65bcf84f3959ef3896f3"
  end

  resource "pip-requirements-parser" do
    url "https://files.pythonhosted.org/packages/5e/2a/63b574101850e7f7b306ddbdb02cb294380d37948140eecd468fae392b54/pip-requirements-parser-32.0.1.tar.gz"
    sha256 "b4fa3a7a0be38243123cf9d1f3518da10c51bdb165a2b2985566247f9155a7d3"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "resolvelib" do
    url "https://files.pythonhosted.org/packages/73/51/36f96ad70dd8c71274ac77739cda0794fee3ba45640373e7f8c5da7c9455/resolvelib-0.9.0.tar.gz"
    sha256 "40ab05117c3281b1b160105e10075094c5ab118315003c922b77673a365290e1"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/68/31/b8934896818c885001aeb7df388ba0523ea3ec88ad31805983d9b0480a50/rich-13.3.1.tar.gz"
    sha256 "125d96d20c92b946b983d0d392b84ff945461e5a06d3867e9f9e575f8697b67f"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
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

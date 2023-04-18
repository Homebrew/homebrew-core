class PipAudit < Formula
  include Language::Python::Virtualenv

  desc "Audits Python environments and dependency trees for known vulnerabilities"
  homepage "https://pypi.org/project/pip-audit/"
  url "https://files.pythonhosted.org/packages/7c/75/c977c23e0e1bcb86ff0f4b987b3501dfd5a0b23e3bed7f7e94c446a713e7/pip_audit-2.5.4.tar.gz"
  sha256 "a4cb03f9e2896d626f5b153973d3ac0d32fdb18594d78d393b153c83bb8089b6"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "705eb2b2e5acabf8fb3d7866e8b7e53559351245bbca898b92a10d123997573b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65ace6a79d21b680d7de070bb6c9b1fbb05df09a0e2bef96d44ec01d3c859b37"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e52f9a9cc2c2cb4e603e029e8ae559ebd2edac9effe28160ac03c79762a2b551"
    sha256 cellar: :any_skip_relocation, ventura:        "25d5ec851e31ca23a540ebbd3585dffaa1812f1d458231d5fa668f4f2dfa1a19"
    sha256 cellar: :any_skip_relocation, monterey:       "8a6e8dc6ea6825177b17fde725f7d63ff581065bdddab169dd7a9f8b327adc48"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ac58c0097bdfe6878ec24e189b91a872499a8ccd67e49ae32534e3dd71c738b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69e1f9ce6366b8683c05efec5c727bfdceab0de6c1f4cb280067955722109d14"
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
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "cyclonedx-python-lib" do
    url "https://files.pythonhosted.org/packages/60/1e/55e5a6c23c029d536626dc93be350c483e2a0d15f87b88ca5cec22eb3ea3/cyclonedx-python-lib-2.7.1.tar.gz"
    sha256 "493bf2f30e26c48f305f745ed8580ce10d05a8d68d62a598fe95f05a0d9007dc"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/5b/65/5dfde43d5e4d7d31a2392bf4aa20e464b8aa0601f34fd9b050781291f666/filelock-3.10.7.tar.gz"
    sha256 "892be14aa8efc01673b5ed6589dbccb95f9a8596f0507e232626155495c18105"
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
    url "https://files.pythonhosted.org/packages/e4/c0/59bd6d0571986f72899288a95d9d6178d0eebd70b6650f1bb3f0da90f8f7/markdown-it-py-2.2.0.tar.gz"
    sha256 "7c9a5e412688bc771c67432cbfebcdd686c93ce6484913dccf06cb5a0bea35a1"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/dc/a1/eba11a0d4b764bc62966a565b470f8c6f38242723ba3057e9b5098678c30/msgpack-1.0.5.tar.gz"
    sha256 "c075544284eadc5cddc70f4757331d99dcbc16b2bbd4849d15f8aae4cf36d31c"
  end

  resource "packageurl-python" do
    url "https://files.pythonhosted.org/packages/91/c7/47a411700a121acc05fe78642b019afe320592078e58c182537c7c65006f/packageurl-python-0.11.1.tar.gz"
    sha256 "bbcc53d2cb5920c815c1626c75992f319bfc450b73893fa7bd8aac5869aa49fe"
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

  resource "rich" do
    url "https://files.pythonhosted.org/packages/9a/50/672a8d347f92bc752b04c338bbf932fbd0104fbc416c82cc91aa5f7b4b0b/rich-13.3.3.tar.gz"
    sha256 "dc84400a9d842b3a9c5ff74addd8eb798d155f36c1c91303888e0a66850d2a15"
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
    url "https://files.pythonhosted.org/packages/21/79/6372d8c0d0641b4072889f3ff84f279b738cd8595b64c8e0496d4e848122/urllib3-1.26.15.tar.gz"
    sha256 "8a388717b9476f934a21484e8c8e61875ab60644d29b9b39e11e4b9dc1c6b305"
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

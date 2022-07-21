class PipAudit < Formula
  include Language::Python::Virtualenv

  desc "Audits Python environments and dependency trees for known vulnerabilities"
  homepage "https://pypi.org/project/pip-audit/"
  url "https://files.pythonhosted.org/packages/28/34/033b06028ed94c93955e0dde6a81377ca5f68a75bcff6aae19a900cb55e7/pip_audit-2.4.2.tar.gz"
  sha256 "b662085ac41ca2340c12c303d421d822ac313b8e3edac359894ff6338cb1f296"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f8bb006092cca5a2de73f6bfe144724984097de8fb144cca5bdbd4a3fc62bb7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1118a90d543413d3b5080a0bab351abf1758a2b99dcc9f23160f15bb1f74bd49"
    sha256 cellar: :any_skip_relocation, monterey:       "5da1b5e808e7b76347b222078563a66ebc685f2c55b5e3075862fad06a8f036d"
    sha256 cellar: :any_skip_relocation, big_sur:        "1514e27a30960e49a5bad7a15719ae9f7bfbb98ad19ada9ca83550395ec4c705"
    sha256 cellar: :any_skip_relocation, catalina:       "2adc40307b87a3cff9611002feea7752671286583403597d67e150994bd3d8c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1ef12b62b454574b3af6583bc6140e1b396ff941c90d068f01b86dab62e6d83"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "CacheControl" do
    url "https://files.pythonhosted.org/packages/46/9b/34215200b0c2b2229d7be45c1436ca0e8cad3b10de42cfea96983bd70248/CacheControl-0.12.11.tar.gz"
    sha256 "a5b9fcc986b184db101aa280b42ecdcdfc524892596f606858e0b7a8b4d9e144"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cc/85/319a8a684e8ac6d87a1193090e06b6bbb302717496380e225ee10487c888/certifi-2022.6.15.tar.gz"
    sha256 "84c85a9078b11105f04f3036a9482ae10e4621616db313fe045dd24743a0820d"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/93/1d/d9392056df6670ae2a29fcb04cfa5cee9f6fbde7311a1bb511d4115e9b7a/charset-normalizer-2.1.0.tar.gz"
    sha256 "575e708016ff3a5e3681541cb9d79312c416835686d054a23accb873b254f413"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "cyclonedx-python-lib" do
    url "https://files.pythonhosted.org/packages/d0/fb/6b7717b0bcdf53b4177c2c2db4cd2beceb24f2c9f3648d375d57f608def0/cyclonedx-python-lib-2.6.0.tar.gz"
    sha256 "8235aad70efc0f84cdf154b8c28802b605ee8133cd5c9a247d834bdb8b6c827a"
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
    url "https://files.pythonhosted.org/packages/22/44/0829b19ac243211d1d2bd759999aa92196c546518b0be91de9cacc98122a/msgpack-1.0.4.tar.gz"
    sha256 "f5d869c18f030202eb412f08b28d2afeea553d6613aee89e200d7aca7ef01f5f"
  end

  resource "packageurl-python" do
    url "https://files.pythonhosted.org/packages/cd/fd/93ee7ed9c41f0a1ad61f98233fce5dfa78e8c79c3ff75e34d08b3d6df91f/packageurl-python-0.10.0.tar.gz"
    sha256 "99df143960b7100fff3b2cf5b0beba2f64b6d8c818f6c9f125aed6fac7438763"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pip-api" do
    url "https://files.pythonhosted.org/packages/69/a2/90dd01b87277ae65a6fb725dae86a039aeb34e24f576600abd0434aa95c4/pip-api-0.0.30.tar.gz"
    sha256 "a05df2c7aa9b7157374bcf4273544201a0c7bae60a9c65bcf84f3959ef3896f3"
  end

  resource "pip-requirements-parser" do
    url "https://files.pythonhosted.org/packages/fc/aa/4fbc8040db7afae616eda6329ddc8ef73afc8bcb611bf9126937970bca83/pip-requirements-parser-31.2.0.tar.gz"
    sha256 "8c2a6f8e091ac2693824a5ef4e3b250226e34f74a20a91a87b9ab0714b47788f"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/59/0f/eb10576eb73b5857bc22610cdfc59e424ced4004fe7132c8f2af2cc168d3/Pygments-2.12.0.tar.gz"
    sha256 "5eb116118f9612ff1ee89ac96437bb6b49e8f04d8a13b514ba26f620208e26eb"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "resolvelib" do
    url "https://files.pythonhosted.org/packages/ac/20/9541749d77aebf66dd92e2b803f38a50e3a5c76e7876f45eb2b37e758d82/resolvelib-0.8.1.tar.gz"
    sha256 "c6ea56732e9fb6fca1b2acc2ccc68a0b6b8c566d8f3e78e0443310ede61dbd37"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/bb/2d/c902484141330ded63c6c40d66a9725f8da5e818770f67241cf429eef825/rich-12.5.1.tar.gz"
    sha256 "63a5c5ce3673d3d5fbbf23cd87e11ab84b6b451436f1b7f19ec54b6bc36ed7ca"
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
    url "https://files.pythonhosted.org/packages/25/36/f056e5f1389004cf886bb7a8514077f24224238a7534497c014a6b9ac770/urllib3-1.26.10.tar.gz"
    sha256 "879ba4d1e89654d9769ce13121e0f94310ea32e8d2f8cf587b77c08bbcdb30d6"
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

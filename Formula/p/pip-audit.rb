class PipAudit < Formula
  include Language::Python::Virtualenv

  desc "Audits Python environments and dependency trees for known vulnerabilities"
  homepage "https://pypi.org/project/pip-audit/"
  url "https://files.pythonhosted.org/packages/c7/32/ebe105786bd61b4bcad4c9dfecf2e0bc301a08dd50c3b47e34291f9cef2f/pip_audit-2.6.1.tar.gz"
  sha256 "55c9bd18b0fe3959f73397db08d257c6012ad1826825e3d74cb6c3f79e95c245"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d554edb653a514cda8422b286977023407fa1fbc073e2117d71f733e0dd4222"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8413bbb5ac419939c2f20b2370113d3af222acf5e239b3a21340c70d8e4c8184"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77a268697fa13b9c06869d78f1a883d74c772940afa8cb68b318cf8cd70c7247"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b05233ca00222ebe6a41fc0b35dcb72fc2ccf523203f212ddd7709f3829116f"
    sha256 cellar: :any_skip_relocation, ventura:        "3e52b18d39c9ea27911d7c7fae3abe6d492a1d5cbc3305dc7d4f0c9b72e2a218"
    sha256 cellar: :any_skip_relocation, monterey:       "47ec7c28aad2f11fdff24bbe50ca4e55edfb296a9de88c62bcf84bf0eb3b1b90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ac7ccb537419b5b9a0079391085a524e8f18527891ff3474c58d7747ff8a2c8"
  end

  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-packaging"
  depends_on "python-pyparsing"
  depends_on "python-toml"
  depends_on "python@3.12"
  depends_on "six"

  resource "boolean-py" do
    url "https://files.pythonhosted.org/packages/a2/d9/b6e56a303d221fc0bdff2c775e4eef7fedd58194aa5a96fa89fb71634cc9/boolean.py-4.0.tar.gz"
    sha256 "17b9a181630e43dde1851d42bef546d616d5d9b4480357514597e78b203d06e4"
  end

  resource "cachecontrol" do
    url "https://files.pythonhosted.org/packages/9e/65/3356cfc87bdee0cdf62d941235e936a26c205e4f1e1f2c85dbd952d7533a/cachecontrol-0.13.1.tar.gz"
    sha256 "f012366b79d2243a6118309ce73151bf52a38d4a5dac8ea57f09bd29087e506b"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "cyclonedx-python-lib" do
    url "https://files.pythonhosted.org/packages/1e/9a/780027d284b3c22ecee842c5b3e2bd0e056381fcb60d7f29818a5243f709/cyclonedx_python_lib-4.2.3.tar.gz"
    sha256 "904068b55d1665f0ea96f38307603cc14f95c3b421f1687fc2411326aefde3a6"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/d5/71/bb1326535231229dd69a9dd2e338f6f54b2d57bd88fc4a52285c0ab8a5f6/filelock-3.12.4.tar.gz"
    sha256 "2e6f249f1f3654291606e046b09f1fd5eac39b360664c27f5aad072012f8bcbd"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "license-expression" do
    url "https://files.pythonhosted.org/packages/90/93/0fc8c72a5c9b65c2fd56154ef9e08c0c7a7fd0596ae69c65ce714ea5cd84/license-expression-30.1.1.tar.gz"
    sha256 "42375df653ad85e6f5b4b0385138b2dbea1f5d66360783d8625c3e4f97f11f0c"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/c2/d5/5662032db1571110b5b51647aed4b56dfbd01bfae789fa566a2be1f385d1/msgpack-1.0.7.tar.gz"
    sha256 "572efc93db7a4d27e404501975ca6d2d9775705c2d922390d878fcf768d92c87"
  end

  resource "packageurl-python" do
    url "https://files.pythonhosted.org/packages/33/34/a7843f732e1e0b01e961f6ae835b3fd6bd4e361c1a3a72debd31244cb718/packageurl-python-0.11.2.tar.gz"
    sha256 "01fbf74a41ef85cf413f1ede529a1411f658bda66ed22d45d27280ad9ceba471"
  end

  resource "pip-api" do
    url "https://files.pythonhosted.org/packages/69/a2/90dd01b87277ae65a6fb725dae86a039aeb34e24f576600abd0434aa95c4/pip-api-0.0.30.tar.gz"
    sha256 "a05df2c7aa9b7157374bcf4273544201a0c7bae60a9c65bcf84f3959ef3896f3"
  end

  resource "pip-requirements-parser" do
    url "https://files.pythonhosted.org/packages/5e/2a/63b574101850e7f7b306ddbdb02cb294380d37948140eecd468fae392b54/pip-requirements-parser-32.0.1.tar.gz"
    sha256 "b4fa3a7a0be38243123cf9d1f3518da10c51bdb165a2b2985566247f9155a7d3"
  end

  resource "py-serializable" do
    url "https://files.pythonhosted.org/packages/aa/2e/70c31636b6eab09f6b1d3372ba350352f7c5c2b93bfd06a1b434f2eede0f/py-serializable-0.11.1.tar.gz"
    sha256 "ba0e1287b9e4f645a5334f1913abd8e647e7250209f84f55dce3909498a6f586"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b1/0e/e5aa3ab6857a16dadac7a970b2e1af21ddf23f03c99248db2c01082090a3/rich-13.6.0.tar.gz"
    sha256 "5c14d22737e6d5084ef4771b62d5d4363165b403455a30a1c8ca39dc7b644bef"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
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

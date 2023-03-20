class Flit < Formula
  include Language::Python::Virtualenv

  desc "Simplified packaging of Python modules"
  homepage "https://github.com/pypa/flit"
  url "https://files.pythonhosted.org/packages/28/c6/c399f38dab6d3a2518a50d334d038083483a787f663743d713f1d245bde3/flit-3.8.0.tar.gz"
  sha256 "d0f2a8f4bd45dc794befbf5839ecc0fd3830d65a57bd52b5997542fac5d5e937"
  license "BSD-3-Clause"
  head "https://github.com/pypa/flit.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c79cd79ddd53d849487514e66f3ce7cd062942639ebfa86b18c45cb032bedf62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1f355701e2e759a91dd1165f9a80127bc2a1ca7ea9f6ea01ab559fd03d5a069"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e89b7fcc04fb5ede6b3ee4468b5890689ee8ec4c47eea3d5b0dfce55cd2c0cb8"
    sha256 cellar: :any_skip_relocation, ventura:        "17b346f784b1ce2d3503cc4f4776e71d05131d85c2080f55f971c5bada781e5c"
    sha256 cellar: :any_skip_relocation, monterey:       "70d5d61f35d5b40ca442f193324101bc7a2fa4f9bc52b275c6dfefbef5a99f4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "356f09a724ecc55cc158ffd911855942b1e67192e76bd893f82adc462e6d34a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84e9f9b69437ee28a56a66cb0bb6fdbd3c32c8dfdd209277cb4f7569c3b65660"
  end

  depends_on "docutils"
  depends_on "python@3.11"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/96/d7/1675d9089a1f4677df5eb29c3f8b064aa1e70c1251a0a8a127803158942d/charset-normalizer-3.0.1.tar.gz"
    sha256 "ebea339af930f8ca5d7a699b921106c6e29c617fe9606fa7baa043c1cdae326f"
  end

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/10/e5/be08751d07b30889af130cec20955c987a74380a10058e6e8856e4010afc/flit_core-3.8.0.tar.gz"
    sha256 "b305b30c99526df5e63d6022dd2310a0a941a187bd3884f4c8ef0418df6c39f3"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/49/05/6bf21838623186b91aedbda06248ad18f03487dc56fbc20e4db384abde6c/tomli_w-1.0.0.tar.gz"
    sha256 "f463434305e0336248cac9c2dc8076b707d8a12d019dd349f5c1e382dd1ae1b9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"sample.py").write <<~END
      """A sample package"""
      __version__ = "0.1"
    END
    (testpath/"pyproject.toml").write <<~END
      [build-system]
      requires = ["flit_core"]
      build-backend = "flit_core.buildapi"

      [tool.flit.metadata]
      module = "sample"
      author = "Sample Author"
    END
    system bin/"flit", "build"
    assert_predicate testpath/"dist/sample-0.1-py2.py3-none-any.whl", :exist?
    assert_predicate testpath/"dist/sample-0.1.tar.gz", :exist?
  end
end

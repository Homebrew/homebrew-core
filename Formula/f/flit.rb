class Flit < Formula
  include Language::Python::Virtualenv

  desc "Simplified packaging of Python modules"
  homepage "https://github.com/pypa/flit"
  url "https://files.pythonhosted.org/packages/b1/a6/e9227cbb501aee4fa4a52517d3868214036a7b085d96bd1e4bbfc67ad6c6/flit-3.9.0.tar.gz"
  sha256 "d75edf5eb324da20d53570a6a6f87f51e606eee8384925cd66a90611140844c7"
  license "BSD-3-Clause"
  revision 4
  head "https://github.com/pypa/flit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7684043a66cbdfa2def6fe59cbf54efddf090c7e626b06f8bf4f7397c1a29e17"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7684043a66cbdfa2def6fe59cbf54efddf090c7e626b06f8bf4f7397c1a29e17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7684043a66cbdfa2def6fe59cbf54efddf090c7e626b06f8bf4f7397c1a29e17"
    sha256 cellar: :any_skip_relocation, sonoma:         "7684043a66cbdfa2def6fe59cbf54efddf090c7e626b06f8bf4f7397c1a29e17"
    sha256 cellar: :any_skip_relocation, ventura:        "7684043a66cbdfa2def6fe59cbf54efddf090c7e626b06f8bf4f7397c1a29e17"
    sha256 cellar: :any_skip_relocation, monterey:       "7684043a66cbdfa2def6fe59cbf54efddf090c7e626b06f8bf4f7397c1a29e17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc985cb96aed9b2ce225c0dc42fbdf5b47d418fea0bf0de99983192701b07024"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/21/ff/c495b797462434f0befcb598b51cde31c3ebdf8577c3fd9d9a8f5eeb844c/docutils-0.21.1.tar.gz"
    sha256 "65249d8a5345bc95e0f40f280ba63c98eb24de35c6c8f5b662e3e8948adea83f"
  end

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/c4/e6/c1ac50fe3eebb38a155155711e6e864e254ce4b6e17fe2429b4c4d5b9e80/flit_core-3.9.0.tar.gz"
    sha256 "72ad266176c4a3fcfab5f2930d76896059851240570ce9a98733b658cb786eba"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/49/05/6bf21838623186b91aedbda06248ad18f03487dc56fbc20e4db384abde6c/tomli_w-1.0.0.tar.gz"
    sha256 "f463434305e0336248cac9c2dc8076b707d8a12d019dd349f5c1e382dd1ae1b9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
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

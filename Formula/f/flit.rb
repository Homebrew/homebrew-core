class Flit < Formula
  include Language::Python::Virtualenv

  desc "Simplified packaging of Python modules"
  homepage "https://github.com/pypa/flit"
  url "https://files.pythonhosted.org/packages/b1/a6/e9227cbb501aee4fa4a52517d3868214036a7b085d96bd1e4bbfc67ad6c6/flit-3.9.0.tar.gz"
  sha256 "d75edf5eb324da20d53570a6a6f87f51e606eee8384925cd66a90611140844c7"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/pypa/flit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e666d7283dbeb116681efd9981abc33a59345df92d17a92e2e44f6e657a924ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ac1cb84bb2754e3eac7bc25fd75b8264a6f75be60bc8b0adf1e64a92c8ca3dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86447821fd7f61943746519c0d8c411e4920ccb7aede7fb6e696b5acf9294094"
    sha256 cellar: :any_skip_relocation, sonoma:         "947f3f0a8399c42a364aba01e41ee1daf7e430fbc57248deb3d3fdc24b3b3bed"
    sha256 cellar: :any_skip_relocation, ventura:        "b939555a001a8b62df449114aca9cfbf3bbd9123e96705c09287891244675669"
    sha256 cellar: :any_skip_relocation, monterey:       "39b4ad0426735ae2805331fca9d1731825c56dea113e305e107a8ccca8a94a55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88fca41340487d622a4dffa4009abd0fabc3ff0f6dc7cd8593527b48f3bb9c50"
  end

  depends_on "docutils"
  depends_on "python-certifi"
  depends_on "python-flit-core"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
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
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
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

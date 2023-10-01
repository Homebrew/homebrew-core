class Flit < Formula
  include Language::Python::Virtualenv

  desc "Simplified packaging of Python modules"
  homepage "https://github.com/pypa/flit"
  url "https://files.pythonhosted.org/packages/b1/a6/e9227cbb501aee4fa4a52517d3868214036a7b085d96bd1e4bbfc67ad6c6/flit-3.9.0.tar.gz"
  sha256 "d75edf5eb324da20d53570a6a6f87f51e606eee8384925cd66a90611140844c7"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/pypa/flit.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59260548ae13718aebd10f443a395131094e81929860f89933a18a946848c9af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59ff232303dcc43553ea52979982d5e04e53db9272ddb82b85306d312341947e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0273a40c31f8dd46bea165bd814ca01e26e4f15ac04f08da87ac4407a434ae0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fdd29305495d29873e462927d4341b521d4363232de5c5fa16fc9b1ee297cddf"
    sha256 cellar: :any_skip_relocation, sonoma:         "477b477e93172c2b57a66fb92cb80dc2f997e81fd4231a30cb18ad6bf04e4360"
    sha256 cellar: :any_skip_relocation, ventura:        "3a06d02585b99afbb19eeaa691164ef6c778dd4810aa671798a72a747145b1b6"
    sha256 cellar: :any_skip_relocation, monterey:       "f59252ac73703cc6b9b078e7472f6ea250a7f564382cff93b7975ea907ebeadc"
    sha256 cellar: :any_skip_relocation, big_sur:        "edcf0b1108d7d53214fc3db22efdead2afd311c0cff16abcd54502abea9a9bc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cc084ba849c30888c6e226b29d4f46d8034c391aeb41f3f89283c042c41511c"
  end

  depends_on "docutils"
  depends_on "python-certifi"
  depends_on "python@3.11"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/c4/e6/c1ac50fe3eebb38a155155711e6e864e254ce4b6e17fe2429b4c4d5b9e80/flit_core-3.9.0.tar.gz"
    sha256 "72ad266176c4a3fcfab5f2930d76896059851240570ce9a98733b658cb786eba"
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
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
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

class Flake8 < Formula
  include Language::Python::Virtualenv

  desc "Lint your Python code for style and logical errors"
  homepage "https://flake8.pycqa.org/"
  url "https://files.pythonhosted.org/packages/cf/f8/bbe24f43695c0c480181e39ce910c2650c794831886ec46ddd7c40520e6a/flake8-6.1.0.tar.gz"
  sha256 "d5b3857f07c030bdb5bf41c7f53799571d75c4491748a3adcd47de929e34cd23"
  license "MIT"
  head "https://github.com/PyCQA/flake8.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f5f3dc0e939dd858867d287622a23a5ed546bd2d74fab4060c95d6dddb5ea0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ce7fa65eee4b484eff26dba35857a77c714d24f769daf512ee206eeddfeb0c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4486f884951c76bcacc8026cca5126ef076a34680ce8eea9b5346718f4458d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a41b391e4a63cc7758ce7f6b6c6707c4d519bb7d5a8dc7b206e87a9707fa86f"
    sha256 cellar: :any_skip_relocation, ventura:        "0588c309bef44bccc07bfebfd392c4e5750975b850a43b67e47c9ade2c67149a"
    sha256 cellar: :any_skip_relocation, monterey:       "178e287b51eae827fd772d1b5c8981ada503d40583d6157b07c10a015d08a498"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38968f72bc2a2b39481af43da62f7232b281954a9682b4be6c39f448e1c96db1"
  end

  depends_on "python@3.12"

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/c1/2d/022c78a6b3f591205e52b4d25c93b7329280f752b36ba2fc1377cbf016cd/pycodestyle-2.11.0.tar.gz"
    sha256 "259bcc17857d8a8b3b4a2327324b79e5f020a13c16074670f9c8c8f872ea76d0"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/8b/fb/7251eaec19a055ec6aafb3d1395db7622348130d1b9b763f78567b2aab32/pyflakes-3.1.0.tar.gz"
    sha256 "a0aae034c444db0071aa077972ba4768d40c830d9539fd45bf4cd3f8f6992efc"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test-bad.py").write <<~EOS
      print ("Hello World!")
    EOS

    (testpath/"test-good.py").write <<~EOS
      print("Hello World!")
    EOS

    assert_match "E211", shell_output("#{bin}/flake8 test-bad.py", 1)
    assert_empty shell_output("#{bin}/flake8 test-good.py")
  end
end

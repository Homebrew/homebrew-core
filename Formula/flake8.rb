class Flake8 < Formula
  include Language::Python::Virtualenv

  desc "Lint your Python code for style and logical errors"
  homepage "https://flake8.pycqa.org/"
  url "https://files.pythonhosted.org/packages/66/53/3ad4a3b74d609b3b9008a10075c40e7c8909eae60af53623c3888f7a529a/flake8-6.0.0.tar.gz"
  sha256 "c61007e76655af75e6785a931f452915b371dc48f56efd765247c8fe68f2b181"
  license "MIT"
  head "https://github.com/PyCQA/flake8.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e1fffd844232e4fae4b7ba7b7d34d8af57be04d43ef550c311c751ac7b53fe9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e1fffd844232e4fae4b7ba7b7d34d8af57be04d43ef550c311c751ac7b53fe9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e1fffd844232e4fae4b7ba7b7d34d8af57be04d43ef550c311c751ac7b53fe9"
    sha256 cellar: :any_skip_relocation, ventura:        "afc41a21bfc1664a09f5618a16a7b2d959e5f48f262855fbc5408162bc064c2e"
    sha256 cellar: :any_skip_relocation, monterey:       "afc41a21bfc1664a09f5618a16a7b2d959e5f48f262855fbc5408162bc064c2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "afc41a21bfc1664a09f5618a16a7b2d959e5f48f262855fbc5408162bc064c2e"
    sha256 cellar: :any_skip_relocation, catalina:       "afc41a21bfc1664a09f5618a16a7b2d959e5f48f262855fbc5408162bc064c2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75e22c8fc2e47031ae6a2c30bb10ad607e8f990483c710f4a458d7383ecf3ea7"
  end

  depends_on "python@3.11"

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/06/6b/5ca0d12ef7dcf7d20dfa35287d02297f3e0f9e515da5183654c03a9636ce/pycodestyle-2.10.0.tar.gz"
    sha256 "347187bdb476329d98f695c213d7295a846d1152ff4fe9bacb8a9590b8ee7053"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/4d/e5/e0d83a25b307ae3d75be40faf72e5d2f1c7bff0534c732deb252e3f86479/pyflakes-3.0.0.tar.gz"
    sha256 "12da339341ba8b9071e185d4717bef732fdb4f4400b9f4a1d0d6bbc362bf7760"
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

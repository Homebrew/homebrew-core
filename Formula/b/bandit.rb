class Bandit < Formula
  include Language::Python::Virtualenv

  desc "Security-oriented static analyser for Python code"
  homepage "https://github.com/PyCQA/bandit"
  url "https://files.pythonhosted.org/packages/aa/c3/0cb80dfe0f3076e5da7e4c5ad8e57bac6ac357ff4a6406205501cade4965/bandit-1.9.4.tar.gz"
  sha256 "b589e5de2afe70bd4d53fa0c1da6199f4085af666fde00e8a034f152a52cd628"
  license "Apache-2.0"
  head "https://github.com/PyCQA/bandit.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e603153517ddc896927a102b1ff5c9145cd3dde0bfc7464e6265396c73791ed7"
    sha256 cellar: :any,                 arm64_sequoia: "35a8204e8f98715465f58d8db81746f4ffc2f255289e9f10aa3a9124adaab81e"
    sha256 cellar: :any,                 arm64_sonoma:  "0fb082d10588db09451af25e065e944715e5a3b1c78b02d7b53f89949d5c7718"
    sha256 cellar: :any,                 sonoma:        "3c3660c6fc3adc80d70e21b2d354bd75601c25dac6d03620a79edc233541eb3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6818bb846a9d0e8fb24e323619b79915b7089acef506004c2a41ceed693ae0a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88cfbf4ff98d367a35a3e8063e58f73d4cff2892b82f7128de29304641251737"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/c6/f3b320c27991c46f43ee9d856302c70dc2d0fb2dba4842ff739d5f46b393/rich-14.3.3.tar.gz"
    sha256 "b8daa0b9e4eef54dd8cf7c86c03713f53241884e814f4e2f5fb342fe520f639b"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/a2/6d/90764092216fa560f6587f83bb70113a8ba510ba436c6476a2b47359057c/stevedore-5.7.0.tar.gz"
    sha256 "31dd6fe6b3cbe921e21dcefabc9a5f1cf848cf538a1f27543721b8ca09948aa3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write "assert True\n"
    output = JSON.parse shell_output("#{bin}/bandit -q -f json test.py", 1)
    assert_equal output["results"][0]["test_id"], "B101"
  end
end

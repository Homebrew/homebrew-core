class Bandit < Formula
  include Language::Python::Virtualenv

  desc "Security-oriented static analyser for Python code"
  homepage "https://github.com/PyCQA/bandit"
  url "https://files.pythonhosted.org/packages/80/d5/82fc87a82ad9536215c1b5693bbb675439f6f2d0c2fca74b2df2cb9db925/bandit-1.9.1.tar.gz"
  sha256 "6dbafd1a51e276e065404f06980d624bad142344daeac3b085121fcfd117b7cf"
  license "Apache-2.0"
  head "https://github.com/PyCQA/bandit.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c54af73093c8c6c90b74a7ff649aa03eb4de14b31332d30e9f6b6d39c609fa18"
    sha256 cellar: :any,                 arm64_sequoia: "cf967393c8c7ad77f6042e4a87cc5ab5c4b4c2b3f66924574ee99313be4540a1"
    sha256 cellar: :any,                 arm64_sonoma:  "95ce385b241dd2f3d16faab16599fad920da3ab00a97e44fe48a9445d6356b0f"
    sha256 cellar: :any,                 sonoma:        "aae16b9217c71aef0cf30a70bbc937b73292e87e51f475a5a57a2a739c5fc1cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f6f2eec51d161479b9d8a4e6df6f3706e96283e0ee7bd2c2982360dc5ad5bdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "606d60fca48562a779add254bf0e1e8b1177d7e1a0b271644b142b778047851d"
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
    url "https://files.pythonhosted.org/packages/fb/d2/8920e102050a0de7bfabeb4c4614a49248cf8d5d7a8d01885fbb24dc767a/rich-14.2.0.tar.gz"
    sha256 "73ff50c7c0c1c77c8243079283f4edb376f0f6442433aecb8ce7e6d0b92d1fe4"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/2a/5f/8418daad5c353300b7661dd8ce2574b0410a6316a8be650a189d5c68d938/stevedore-5.5.0.tar.gz"
    sha256 "d31496a4f4df9825e1a1e4f1f74d19abb0154aff311c3b376fcc89dae8fccd73"
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

class Bandit < Formula
  include Language::Python::Virtualenv

  desc "Security-oriented static analyser for Python code"
  homepage "https://github.com/PyCQA/bandit"
  url "https://files.pythonhosted.org/packages/89/76/a7f3e639b78601118aaa4a394db2c66ae2597fbd8c39644c32874ed11e0c/bandit-1.9.3.tar.gz"
  sha256 "ade4b9b7786f89ef6fc7344a52b34558caec5da74cb90373aed01de88472f774"
  license "Apache-2.0"
  head "https://github.com/PyCQA/bandit.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "57541c07735da527c0164f5e6cd784ed7358ab738321c2552335fb1c4d8f9e7a"
    sha256 cellar: :any,                 arm64_sequoia: "58e377eaac796ee812a6deb4a4272c7b1865fb9eb84a343da19d994c437bf80a"
    sha256 cellar: :any,                 arm64_sonoma:  "b7cd95291ace269e3b2aa697405a239133dbc073760ec1f9667d404ebb2ddda0"
    sha256 cellar: :any,                 sonoma:        "f12a3c3eb5beeafcef5169e2b1987a84b2453dd9bbc784fd275b8a2142970fa7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64437bd93c93e8c342c06ea704d727c981e9bf223fbd00e5f1dc0f405f496726"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4af46fdade697d9e7910bc64862a5373b204d24d6a8aab19ee57ae779cfc384c"
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
    url "https://files.pythonhosted.org/packages/96/5b/496f8abebd10c3301129abba7ddafd46c71d799a70c44ab080323987c4c9/stevedore-5.6.0.tar.gz"
    sha256 "f22d15c6ead40c5bbfa9ca54aa7e7b4a07d59b36ae03ed12ced1a54cf0b51945"
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

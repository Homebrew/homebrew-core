class Bandit < Formula
  include Language::Python::Virtualenv

  desc "Security-oriented static analyser for Python code"
  homepage "https://github.com/PyCQA/bandit"
  url "https://files.pythonhosted.org/packages/aa/c3/0cb80dfe0f3076e5da7e4c5ad8e57bac6ac357ff4a6406205501cade4965/bandit-1.9.4.tar.gz"
  sha256 "b589e5de2afe70bd4d53fa0c1da6199f4085af666fde00e8a034f152a52cd628"
  license "Apache-2.0"
  revision 1
  head "https://github.com/PyCQA/bandit.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "84dadd0f1b4908e7d570e0e9c85cccdcf6eba696b171e2e7111fa9a1e503dfce"
    sha256 cellar: :any, arm64_tahoe:       "7b220b15e11f7bf7409104f55e23587b98ccfbbd79fdd7192a7884a484bf703c"
    sha256 cellar: :any, arm64_sequoia:     "f6b617a2bbb58d5a64776529a66ac2e667d9c55853d7dcfca0816129d4268b0b"
    sha256 cellar: :any, arm64_linux:       "1d0aa9c16fa45750c353feda2663b65b3a674f337050e51137ca58a4f4651f59"
    sha256 cellar: :any, x86_64_linux:      "a6a0d8217cb5949023f91ae4fa0d4dbae96a36068f93612256bdebac3507b1af"
  end

  depends_on "libyaml"
  depends_on "python@3.15"

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/db/a1/3b8ed9c1fc3aa6eebb57732d924ddaa0500ecc3b638d0454816320994383/stevedore-5.9.1.tar.gz"
    sha256 "e97a2667923efda926e8713fde6a73616df68210a3cbc6f02b48967b676fd8bf"
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

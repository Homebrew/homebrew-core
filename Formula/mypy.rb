class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/9a/d0/d96d26e7a6f5a2ed4add8c649f30bce26fc413f25a6ecc5d93ab22c270e1/mypy-1.2.0.tar.gz"
  sha256 "f70a40410d774ae23fcb4afbbeca652905a04de7948eaf0b1789c8d1426b72d1"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6222a1b3de44275a7af3e241318913f484a5e61f9353afcb62c8f7daec2b36e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a9f765fd3809c2e63a1445f9eadd4205bb87bf853290b9f30d934a626d79d87"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90d0fc942da809bf4c5f15c2c8151b25c9c7a9d53f26726803fd279e953c56e1"
    sha256 cellar: :any_skip_relocation, ventura:        "4d1fe62fd1ae9148bbf292702d9a4c6c65bafd890e5338813a67893972b16886"
    sha256 cellar: :any_skip_relocation, monterey:       "2415c2e48ac806e750411debdafea4c95d7ecfb7c18c1a4504b4ad986d64c472"
    sha256 cellar: :any_skip_relocation, big_sur:        "e3e7a88bb30f45b3b3baeb952098b1deb60c89a8c77fcfe82cbe5ceec39945ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f87f91d7694b73b82c614e10019bca108696c2d5bb65db22e59f8ee767447c5b"
  end

  depends_on "python@3.11"

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/98/a4/1ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3f/mypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/d3/20/06270dac7316220643c32ae61694e451c98f8caf4c8eab3aa80a2bedf0df/typing_extensions-4.5.0.tar.gz"
    sha256 "5cb5f4a79139d699607b3ef622a1dedafa84e115ab0024e0d9c044a9479ca7cb"
  end

  def install
    ENV["MYPY_USE_MYPYC"] = "1"
    ENV["MYPYC_OPT_LEVEL"] = "3"
    virtualenv_install_with_resources
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def p() -> None:
        print('hello')
      a = p()
    EOS
    output = pipe_output("#{bin}/mypy broken.py 2>&1")
    assert_match '"p" does not return a value', output

    output = pipe_output("#{bin}/mypy --version 2>&1")
    assert_match "(compiled: yes)", output
  end
end

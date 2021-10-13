class Darglint < Formula
  include Language::Python::Virtualenv

  desc "Python docstring argument linter"
  homepage "https://github.com/terrencepreilly/darglint"
  url "https://files.pythonhosted.org/packages/8d/1a/86f981066bc6f9d90d73da0ce09d2084abf1a0fafa9f28fb5130b7186da2/darglint-1.8.0.tar.gz"
  sha256 "aa605ef47817a6d14797d32b390466edab621768ea4ca5cc0f3c54f6d8dcaec8"
  license "MIT"
  revision 1
  head "https://github.com/terrencepreilly/darglint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b04a5b6ae464c02fd2e219a2469c46241511566f44f86889aadc4f0af8752bd8"
    sha256 cellar: :any_skip_relocation, big_sur:       "2fd92517a8083dcddf0f1c0d863d399d8ee303e20141c1c2bb523de112af59aa"
    sha256 cellar: :any_skip_relocation, catalina:      "1d6b6b50b49117b0df3899e90cd2edfca17708083de4212185335ae1251360ff"
    sha256 cellar: :any_skip_relocation, mojave:        "a1419f06b43128eb19a7af6a5ac0d2d497fbb791e82d282738f892cf039ba3c2"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def bad_docstring(x):
        """nothing about x"""
        pass
    EOS
    output = pipe_output("#{bin}/darglint -v 2 broken.py 2>&1")
    assert_match "DAR101: Missing parameter(s) in Docstring: - x", output
  end
end

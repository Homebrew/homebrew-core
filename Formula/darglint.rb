class Darglint < Formula
  include Language::Python::Virtualenv

  desc "Python docstring argument linter"
  homepage "https://github.com/terrencepreilly/darglint"
  url "https://files.pythonhosted.org/packages/8d/1a/86f981066bc6f9d90d73da0ce09d2084abf1a0fafa9f28fb5130b7186da2/darglint-1.8.0.tar.gz"
  sha256 "aa605ef47817a6d14797d32b390466edab621768ea4ca5cc0f3c54f6d8dcaec8"
  license "MIT"
  head "https://github.com/terrencepreilly/darglint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9c9b15a285b22cf03670850d24c7896246acb333c0d548d9d252bcf1f1f242aa"
    sha256 cellar: :any_skip_relocation, big_sur:       "b02d50b5140296e947def3daa60b5c85814de8b2801ac8b467ba98667f1a8bf1"
    sha256 cellar: :any_skip_relocation, catalina:      "7baab8fba04fc191938885ff7e86990d94dce84ff3c7407ede352fbdd7d3456b"
    sha256 cellar: :any_skip_relocation, mojave:        "4df445fe8a9aeb76d8ea3da5eaedca03f42bf39f4c227064e8ab447ab68ba362"
  end

  depends_on "python@3.9"

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

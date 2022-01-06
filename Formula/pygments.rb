class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/94/9c/cb656d06950268155f46d4f6ce25d7ffc51a0da47eadf1b164bbf23b718b/Pygments-2.11.2.tar.gz"
  sha256 "4e426f72023d88d03b2fa258de560726ce890ff3b630f88c21cbb8b2503b8c6a"
  license "BSD-2-Clause"
  head "https://github.com/pygments/pygments.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ef6c0c139f127440c9ce727940aec734dbeda508fd2c6a1b907d9561de77104"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ef6c0c139f127440c9ce727940aec734dbeda508fd2c6a1b907d9561de77104"
    sha256 cellar: :any_skip_relocation, monterey:       "3fc2c4caa0cfa346a35ed0e7eba4f90712c16e5c85b0c39ed83c6e4f40080516"
    sha256 cellar: :any_skip_relocation, big_sur:        "3fc2c4caa0cfa346a35ed0e7eba4f90712c16e5c85b0c39ed83c6e4f40080516"
    sha256 cellar: :any_skip_relocation, catalina:       "3fc2c4caa0cfa346a35ed0e7eba4f90712c16e5c85b0c39ed83c6e4f40080516"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c7dcc1ef70298a38634b5789329cc77391cf4ca6894b9c9cba1584cec0004f9"
  end

  depends_on "python@3.10"

  def install
    bash_completion.install "external/pygments.bashcomp" => "pygmentize"
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
      print(os.getcwd())
    EOS

    system bin/"pygmentize", "-f", "html", "-o", "test.html", testpath/"test.py"
    assert_predicate testpath/"test.html", :exist?
  end
end

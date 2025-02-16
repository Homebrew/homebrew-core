class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
  sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  license "BSD-2-Clause"
  head "https://github.com/pygments/pygments.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "98328d1e104147cef03596a6f3be5ef664810d9cae9cf17d6d8eaf2803285775"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
    bash_completion.install "external/pygments.bashcomp" => "pygmentize"
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      import os
      print(os.getcwd())
    PYTHON

    system bin/"pygmentize", "-f", "html", "-o", "test.html", testpath/"test.py"
    assert_path_exists testpath/"test.html"
  end
end

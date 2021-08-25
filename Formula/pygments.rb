class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/b7/b3/5cba26637fe43500d4568d0ee7b7362de1fb29c0e158d50b4b69e9a40422/Pygments-2.10.0.tar.gz"
  sha256 "f398865f7eb6874156579fdf36bc840a03cab64d1cde9e93d68f46a425ec52c6"
  license "BSD-2-Clause"
  head "https://github.com/pygments/pygments.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bbbc9b45672d492c1690b3528b4801088698f3aa37507daa00b9c6e734bd7867"
    sha256 cellar: :any_skip_relocation, big_sur:       "3017eabf88cae57480f64eb286b085b657d82d786c3164dcc0a9ae7c364f28a5"
    sha256 cellar: :any_skip_relocation, catalina:      "3017eabf88cae57480f64eb286b085b657d82d786c3164dcc0a9ae7c364f28a5"
    sha256 cellar: :any_skip_relocation, mojave:        "3017eabf88cae57480f64eb286b085b657d82d786c3164dcc0a9ae7c364f28a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb7f8e59cb96f9ecef4e262dcc90f8e550b267f88bfeb47d7d68b54746e221c8"
  end

  depends_on "python@3.9"

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

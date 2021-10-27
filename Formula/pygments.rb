class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/b7/b3/5cba26637fe43500d4568d0ee7b7362de1fb29c0e158d50b4b69e9a40422/Pygments-2.10.0.tar.gz"
  sha256 "f398865f7eb6874156579fdf36bc840a03cab64d1cde9e93d68f46a425ec52c6"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/pygments/pygments.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c625b002e4402b4c7fdecded981fa7ff87e1514d284e4057011d041d12ad093e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c625b002e4402b4c7fdecded981fa7ff87e1514d284e4057011d041d12ad093e"
    sha256 cellar: :any_skip_relocation, monterey:       "7095fda62baec826a619282cd127e03eed82a02368eafcc4e22ea5fdb1a4ca10"
    sha256 cellar: :any_skip_relocation, big_sur:        "7095fda62baec826a619282cd127e03eed82a02368eafcc4e22ea5fdb1a4ca10"
    sha256 cellar: :any_skip_relocation, catalina:       "7095fda62baec826a619282cd127e03eed82a02368eafcc4e22ea5fdb1a4ca10"
    sha256 cellar: :any_skip_relocation, mojave:         "7095fda62baec826a619282cd127e03eed82a02368eafcc4e22ea5fdb1a4ca10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd675d1a3d161a05a82e0a4819eeb4464219e9eba491b6af816bff8820ce3e20"
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

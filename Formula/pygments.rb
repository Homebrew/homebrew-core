class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/1d/60/bb5bdd45e28a5acecf9273350b903fb8151ed899c4a384c983efd8a6730b/Pygments-2.11.0.tar.gz"
  sha256 "51130f778a028f2d19c143fce00ced6f8b10f726e17599d7e91b290f6cbcda0c"
  license "BSD-2-Clause"
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

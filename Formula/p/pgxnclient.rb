class Pgxnclient < Formula
  include Language::Python::Virtualenv

  desc "Command-line client for the PostgreSQL Extension Network"
  homepage "https://pgxn.github.io/pgxnclient/"
  url "https://files.pythonhosted.org/packages/54/3d/5eae61996702ce218548a98f6ccc930a80b1e4b09b7a8384b1a95129a9c2/pgxnclient-1.3.2.tar.gz"
  sha256 "b0343e044b8d0044ff4be585ecce0147b1007db7ae8b12743bf222758a4ec7d9"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/pgxn/pgxnclient.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "34e47292dc284c01c684578dca761037d87b54c15d33de6d2be31e3f015a0001"
  end

  depends_on "python@3.14"

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def install
    venv = virtualenv_install_with_resources
    inreplace venv.site_packages/name/"__init__.py",
              "/usr/local/libexec/pgxnclient", venv.site_packages/name/"libexec"
  end

  test do
    assert_match "pgxn", shell_output("#{bin}/pgxnclient mirror")
    assert_match version.to_s, shell_output("#{bin}/pgxnclient --version")
    assert_match "site-packages/#{name}/libexec", shell_output("#{bin}/pgxn help --libexec")
  end
end

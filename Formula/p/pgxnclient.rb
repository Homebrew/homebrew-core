class Pgxnclient < Formula
  include Language::Python::Virtualenv

  desc "Command-line client for the PostgreSQL Extension Network"
  homepage "https://pgxn.github.io/pgxnclient/"
  url "https://files.pythonhosted.org/packages/54/3d/5eae61996702ce218548a98f6ccc930a80b1e4b09b7a8384b1a95129a9c2/pgxnclient-1.3.2.tar.gz"
  sha256 "b0343e044b8d0044ff4be585ecce0147b1007db7ae8b12743bf222758a4ec7d9"
  license "BSD-3-Clause"
  revision 2

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "f1b1f557db76ca77277fc59e96c5432107680f75068454279508736f0ccb4116"
  end

  depends_on "python@3.13"

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    venv = virtualenv_install_with_resources
    inreplace venv.site_packages/name/"__init__.py",
              "/usr/local/libexec/pgxnclient", HOMEBREW_PREFIX/"libexec/#{name}"
  end

  test do
    assert_match "pgxn", shell_output("#{bin}/pgxnclient mirror")
    assert_match version.to_s, shell_output("#{bin}/pgxnclient --version")
    assert_match "#{HOMEBREW_PREFIX}/libexec/#{name}", shell_output("#{bin}/pgxn help --libexec")
  end
end

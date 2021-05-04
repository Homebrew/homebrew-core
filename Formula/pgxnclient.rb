class Pgxnclient < Formula
  include Language::Python::Virtualenv

  desc "Command-line client for the PostgreSQL Extension Network"
  homepage "https://pgxn.github.io/pgxnclient/"
  url "https://github.com/pgxn/pgxnclient/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "5d711010b53f257c35e8cb2fe8f954567c736d9af528e0da32227fdcaefe4350"
  license "BSD-3-Clause"

  depends_on "python@3.9"
  depends_on "six"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pgxn", shell_output("#{bin}/pgxnclient mirror")
  end
end

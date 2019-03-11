class EgExamples < Formula
  include Language::Python::Virtualenv

  desc "Useful examples at the command-line"
  homepage "https://github.com/srsudar/eg"
  url "https://files.pythonhosted.org/packages/a6/93/38075713a7968a9e8484e894f604f99a68e443e0f9db0ed48063b1241969/eg-1.1.1.tar.gz"
  sha256 "3faa5fb453d8ba113975a1f31e37ace94867539ba9d46a40af4cea90028a04e4"

  bottle do
    cellar :any_skip_relocation
    sha256 "876d92f8a25f1c00a95d52f2e72e63c91e0cc963852be31968700bc620b5d338" => :mojave
    sha256 "784192ef1d7a869c81793333bc1cb20b0ec53380c7fe8e6f0c1b2e68e71f69a7" => :high_sierra
    sha256 "b97620b249f6b74425c157c068b415b4368245f7ce6d2a20d92b9a2db7230547" => :sierra
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal version, shell_output("#{bin}/eg --version")

    output = shell_output("#{bin}/eg whatis")
    assert_match "search for entries containing a command", output
  end
end

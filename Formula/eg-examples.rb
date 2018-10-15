class EgExamples < Formula
  include Language::Python::Virtualenv

  desc "Useful examples at the command-line"
  homepage "https://github.com/srsudar/eg"
  url "https://files.pythonhosted.org/packages/a6/93/38075713a7968a9e8484e894f604f99a68e443e0f9db0ed48063b1241969/eg-1.1.1.tar.gz"
  sha256 "3faa5fb453d8ba113975a1f31e37ace94867539ba9d46a40af4cea90028a04e4"

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

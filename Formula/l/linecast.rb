class Linecast < Formula
  include Language::Python::Virtualenv

  desc "Weather, tides, the sun, the moon, and maps, drawn for the terminal"
  homepage "https://github.com/ashuttl/linecast"
  url "https://files.pythonhosted.org/packages/73/4d/1273a8fc32e2dc18f7ef993a1df02b358ce6b87287e7c675efeb64470274/linecast-2.7.0.tar.gz"
  sha256 "f9a347a6d9e692f8a310a12f617b91ee94ec189787bfbaff2bdd007150052ea9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e6e3297cfc06d025d13bc9d047955e5febe799e49c045424af5c628f1e0832f4"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/linecast --version")

    output = shell_output("#{bin}/linecast sunshine --location 43.657,-70.258 --json")
    assert_match '"schema": 1', output
    assert_match '"sunrise":', output
    assert_match '"sunset":', output
  end
end

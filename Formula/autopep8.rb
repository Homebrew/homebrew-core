class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/32/23/3bc0b99f932155c19e8b6b4f01021b735727ee6b0ccda6b8e5f99bef1b6d/autopep8-1.5.5.tar.gz"
  sha256 "cae4bc0fb616408191af41d062d7ec7ef8679c7f27b068875ca3a9e2878d5443"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ada2ccfd2662a8b51baca7ba6d8b7ac2d56615439d21f79014f2e596bbece49d"
    sha256 cellar: :any_skip_relocation, big_sur:       "a50d7391893a20c137ba971ef2119ab63f5ceaca21d35fee6e8bda5472a6c6b2"
    sha256 cellar: :any_skip_relocation, catalina:      "8ee96be12db50876b59fd7527e5ac37e78956a1e0a7afee54c37606057b0512b"
    sha256 cellar: :any_skip_relocation, mojave:        "f988eb964253d539121936ee925466884bfd57adea919a642d926b5ee5c6188a"
    sha256 cellar: :any_skip_relocation, high_sierra:   "b0105ebba5fe631f32f32a097c15ac904f363746d5945c7d16f994e7dd0cb129"
  end

  depends_on "python@3.9"

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/bb/82/0df047a5347d607be504ad5faa255caa7919562962b934f9372b157e8a70/pycodestyle-2.6.0.tar.gz"
    sha256 "c58a7d2815e0e8d7972bf1803331fb0152f867bd89adf8a01dfd55085434192e"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("echo \"x='homebrew'\" | #{bin}/autopep8 -")
    assert_equal "x = 'homebrew'", output.strip
  end
end

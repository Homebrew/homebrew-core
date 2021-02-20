class OpenAdventure < Formula
  include Language::Python::Virtualenv
  desc "Colossal Cave Adventure, the 1995 430-point version"
  homepage "http://www.catb.org/~esr/open-adventure/"
  url "http://www.catb.org/~esr/open-adventure/advent-1.9.tar.gz"
  sha256 "36466882af195d402b62deaa08e4cef26d1646cf1329f14503ea06fdc5c7219e"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/open-adventure"

  depends_on "asciidoc" => :build
  depends_on "python@3.9" => :build

  uses_from_macos "libedit" => :build
  uses_from_macos "libxml2" => :build

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  def install
    venv = virtualenv_create(libexec, "python3.9")
    venv.pip_install resources
    system libexec/"bin/python", "./make_dungeon.py"
    system "make"
    bin.install "advent"
    system "make", "advent.6"
    man6.install "advent.6"
  end

  test do
    # there's no apparent way to get non-interactive output without providing an invalid option
    output = shell_output("#{bin}/advent --invalid-option 2>&1", 1)
    assert_match "Usage: #{bin}/advent", output
  end
end

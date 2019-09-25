class Mackup < Formula
  include Language::Python::Virtualenv

  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://github.com/lra/mackup/archive/0.8.27.tar.gz"
  sha256 "b7d84ea661de27b1d4664bb71e6ab52ef30c6ca180a67435c1d4dea073cb3e4c"
  head "https://github.com/lra/mackup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f80bd4765b5a3489d6faa6ef1099ca97478f30ba19d9ba8ce7df33f8e0a6b040" => :mojave
    sha256 "f0dc845d67a9638952e453f5668da070f879c6af12e703966a4a346f59d32b61" => :high_sierra
    sha256 "c941c433ddcb1f6deee07ade71d4d3a9f910e229bb01601402377ebca43411fd" => :sierra
  end

  depends_on "python"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/mackup", "--help"
  end
end

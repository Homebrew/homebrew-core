class Mackup < Formula
  include Language::Python::Virtualenv

  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://github.com/lra/mackup/archive/0.8.29.tar.gz"
  sha256 "2be19200ed93d277dc5ac91bae392a88c1ce31d49181ba5a6ca4e5193333ff29"
  license "GPL-3.0"
  head "https://github.com/lra/mackup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "be195c66e0330cd8cbc4bef06e8be0d919d613774870de537af8b6ef81d22ad2" => :catalina
    sha256 "8ee4dc679e9c944d3407febb22b7b0cb59fc2cd45308ffaf637ff0e11bb26604" => :mojave
    sha256 "da0ee240b7e1b3626becaea6b66673a58a9c0ec803e6e5da4e4f95672a51879b" => :high_sierra
  end

  depends_on "python@3.8"

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

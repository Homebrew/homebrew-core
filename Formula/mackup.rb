class Mackup < Formula
  include Language::Python::Virtualenv

  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://github.com/lra/mackup/archive/0.8.28.tar.gz"
  sha256 "b4a586d12460df00a8322e0ffc8454fe0816630bd97640cd08b87fa0de6c1ba6"
  revision 1
  head "https://github.com/lra/mackup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dbc5ac8b84c362ff421aff6b75819145c9033b72cb1f819dc182964e59b8221e" => :catalina
    sha256 "dcd2364073468374ed2d60f921546db1948ca14efc5e7f0751873b7d89b5c8ba" => :mojave
    sha256 "3af5af899b13058a5887831beffbeada93ceb76a0c2598cbd9675cf11162d8c1" => :high_sierra
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

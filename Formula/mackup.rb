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
    sha256 "06bf4f9daac1ea99a2610a8aa999759143910000c99dccba20e026ac996e196d" => :catalina
    sha256 "b7c11a4fcd021392c3a7f290143f7f971e6c5608f3a1ce03e8f61ea04dc66f8b" => :mojave
    sha256 "d19deabf63c0518d4733458caa7f7f502ef90e30611836b8d3ffe394a46bfcb6" => :high_sierra
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

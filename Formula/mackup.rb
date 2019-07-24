class Mackup < Formula
  include Language::Python::Virtualenv

  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://github.com/lra/mackup/archive/0.8.25.tar.gz"
  sha256 "13e68bde2dee8033a292d820a724d42bcb9e0ba21a7844111a95b440d3b1903b"
  head "https://github.com/lra/mackup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "75d05ae40d68151a05c113c7887280d343fee356e0cb3f76b546c92073203119" => :mojave
    sha256 "79ed8709ce02d8b3d94e139d21a4b6726e434d52df3f9142ea7e45bea47c42b0" => :high_sierra
    sha256 "5b7c88fc3fe73913350e5c4486f3e529ec0b1d6f9e782ded7bbe4d0868fd1b4a" => :sierra
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

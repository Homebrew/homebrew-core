class Mackup < Formula
  include Language::Python::Virtualenv

  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://github.com/lra/mackup/archive/0.8.29.tar.gz"
  sha256 "2be19200ed93d277dc5ac91bae392a88c1ce31d49181ba5a6ca4e5193333ff29"
  license "GPL-3.0"
  revision 1
  head "https://github.com/lra/mackup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b76ef684413cff5aa37666202ee84a0e42c7db942689ddf6d815a1f3b48352a1" => :catalina
    sha256 "e2a3b323ac3b0d57ae3962d996b959ebdec5008db19a9495343f5987542ba5a8" => :mojave
    sha256 "c8043863b82bf5acd733c235e64005782ec26e516c66477527fde373819535d8" => :high_sierra
  end

  depends_on "python@3.9"

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

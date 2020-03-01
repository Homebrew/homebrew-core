class Mackup < Formula
  include Language::Python::Virtualenv

  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://github.com/lra/mackup/archive/0.8.28.tar.gz"
  sha256 "b4a586d12460df00a8322e0ffc8454fe0816630bd97640cd08b87fa0de6c1ba6"
  head "https://github.com/lra/mackup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "08e307fb2b1ad49f54d6e042f2aef44ddad7fab38d69eb80d2a31bf4d6b3bc6d" => :catalina
    sha256 "1e03d73d981c1cbc0d49da9058eb508b58293e6f4ad8bdbaf6dbb832d40d4dab" => :mojave
    sha256 "8f7d3568073793ef4d511ff7bbb67d8d6b68518af8fd68c862b89c23b53176d7" => :high_sierra
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

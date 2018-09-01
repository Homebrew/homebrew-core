class Mackup < Formula
  include Language::Python::Virtualenv

  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://github.com/lra/mackup/archive/0.8.19.tar.gz"
  sha256 "28c1318a716acd6e9b3ec6ccf5c8a0087dbeb8c46ccef78d1891479dd4ccf31a"
  head "https://github.com/lra/mackup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d65e929160426fb570d378bdfadada7378cce9a73c053e2ae38a54cc7383973" => :mojave
    sha256 "b2087f95402ac5cb65f9e26636e86989f66922a24e22938444bb0ee9c84216b1" => :high_sierra
    sha256 "b2087f95402ac5cb65f9e26636e86989f66922a24e22938444bb0ee9c84216b1" => :sierra
    sha256 "de89332a8a2ab48d0b71f1d24f444f6376cbba4077f9fa1214b03a20a58538ec" => :el_capitan
  end

  depends_on "python"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/mackup", "--help"
  end
end

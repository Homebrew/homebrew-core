class Mackup < Formula
  include Language::Python::Virtualenv

  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://github.com/lra/mackup/archive/0.8.21.tar.gz"
  sha256 "adc68e53513c50888580b82f435761db93af901e7022c650d4467c2438e67db1"
  head "https://github.com/lra/mackup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2050deb73ca666b5edcd7f4da3f3937cdfa88a74418ee03cdaf901b52b0e4e9e" => :mojave
    sha256 "384abe552cbc46a1728f7c6ae5e5c6a0d7cf65ece4b38d3f8f2dc43cbd5d6df9" => :high_sierra
    sha256 "8c97af873565669874cdfc9ad461af8d5d54679e09390b2bb9b323d5998098a4" => :sierra
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

class Mackup < Formula
  include Language::Python::Virtualenv

  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://files.pythonhosted.org/packages/66/de/e2c0c5145046cd261b4564840ee7fef66a278fa11d5db082e5659535cdc1/mackup-0.8.29.tar.gz"
  sha256 "6918d9caba1c0e849f63f1868ce3c51e87d33ce0e5a5eb4266a553b6ac22871e"
  license "GPL-3.0"
  revision 1
  head "https://github.com/lra/mackup.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "bb9acba90780a9b523ae03177434d43906bea0781d0909675f2348c11556667b" => :big_sur
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
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/mackup", "--help"
  end
end

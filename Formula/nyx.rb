class Nyx < Formula
  include Language::Python::Virtualenv

  desc "Command-line monitor for Tor"
  homepage "https://nyx.torproject.org/"
  url "https://files.pythonhosted.org/packages/f4/da/68419425cb0f64f996e2150045c7043c2bb61f77b5928c2156c26a21db88/nyx-2.1.0.tar.gz"
  sha256 "88521488d1c9052e457b9e66498a4acfaaa3adf3adc5a199892632f129a5390b"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "606f92ecc381c9d319537d607305fdaae230de8e426e6d5df41fc0c878f2a0d1" => :catalina
    sha256 "21ed9b2f6e986b53916eedad3e5d69a8d3c32fedfd61824e78381d68ec7b548d" => :mojave
    sha256 "61f9d689b22252460f42ec83b59a425f6d3a77d308d741360afa6435c429ed62" => :high_sierra
  end

  depends_on "python@3.8"

  resource "stem" do
    url "https://files.pythonhosted.org/packages/71/bd/ab05ffcbfe74dca704e860312e00c53ef690b1ddcb23be7a4d9ea4f40260/stem-1.8.0.tar.gz"
    sha256 "a0b48ea6224e95f22aa34c0bc3415f0eb4667ddeae3dfb5e32a6920c185568c2"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Errno 61", shell_output("#{bin}/nyx -i 127.0.0.1:9000", 1)
  end
end

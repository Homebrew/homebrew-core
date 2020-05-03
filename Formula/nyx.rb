class Nyx < Formula
  include Language::Python::Virtualenv

  desc "Command-line monitor for Tor"
  homepage "https://nyx.torproject.org/"
  url "https://files.pythonhosted.org/packages/f4/da/68419425cb0f64f996e2150045c7043c2bb61f77b5928c2156c26a21db88/nyx-2.1.0.tar.gz"
  sha256 "88521488d1c9052e457b9e66498a4acfaaa3adf3adc5a199892632f129a5390b"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "a92eabd02b2b59ac8f71aa0b6669b8ec6a8123b46a0eca100e20bc9661b90e48" => :catalina
    sha256 "e45539c22cd0a63392fc06b83824094917c40f6bcbb2d3e05b95dfb2210f8556" => :mojave
    sha256 "e45539c22cd0a63392fc06b83824094917c40f6bcbb2d3e05b95dfb2210f8556" => :high_sierra
    sha256 "1becd20ec7f74fe0fb05655320ab0329562fdd119a8f29acfd3c80a3594d1564" => :sierra
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

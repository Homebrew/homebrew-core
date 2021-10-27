class Nyx < Formula
  include Language::Python::Virtualenv

  desc "Command-line monitor for Tor"
  homepage "https://nyx.torproject.org/"
  url "https://files.pythonhosted.org/packages/f4/da/68419425cb0f64f996e2150045c7043c2bb61f77b5928c2156c26a21db88/nyx-2.1.0.tar.gz"
  sha256 "88521488d1c9052e457b9e66498a4acfaaa3adf3adc5a199892632f129a5390b"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bae78955aa83e7e742c86ead94067128d34ee67e46d3df228782bb14e3ff1933"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bae78955aa83e7e742c86ead94067128d34ee67e46d3df228782bb14e3ff1933"
    sha256 cellar: :any_skip_relocation, monterey:       "e3361830a3dca5a02c43318bac9b699b6716ccf4b75fd3a2106a4b48bd4915dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "e3361830a3dca5a02c43318bac9b699b6716ccf4b75fd3a2106a4b48bd4915dc"
    sha256 cellar: :any_skip_relocation, catalina:       "e3361830a3dca5a02c43318bac9b699b6716ccf4b75fd3a2106a4b48bd4915dc"
    sha256 cellar: :any_skip_relocation, mojave:         "e3361830a3dca5a02c43318bac9b699b6716ccf4b75fd3a2106a4b48bd4915dc"
  end

  depends_on "python@3.10"

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

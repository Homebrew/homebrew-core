class Nyx < Formula
  include Language::Python::Virtualenv

  desc "Command-line monitor for Tor"
  homepage "https://nyx.torproject.org/"
  url "https://files.pythonhosted.org/packages/f4/da/68419425cb0f64f996e2150045c7043c2bb61f77b5928c2156c26a21db88/nyx-2.1.0.tar.gz"
  sha256 "88521488d1c9052e457b9e66498a4acfaaa3adf3adc5a199892632f129a5390b"
  revision 2

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a78e5ce784aeefb44ab69069294cf4aa306e8d9c3ed03ba6bf6883729094e396" => :big_sur
    sha256 "0588b4c6b3df71714a500b85096f5b83d2773cff86bec2d77ae11139117385ed" => :arm64_big_sur
    sha256 "23791dab3ee8f90133cb743c9bdc2e16ac65ffe2346bba10c14f1a0bf8d553c3" => :catalina
    sha256 "4a219bd35ad035daf11653bc1f98c245fcb380c674f218598e6aeedc3271c4b6" => :mojave
    sha256 "50bf36b910c98d16a0bdee31c76ec4ba1a0ef4b8f6ad1cad7ebdb035f05fd286" => :high_sierra
  end

  depends_on "python@3.9"

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

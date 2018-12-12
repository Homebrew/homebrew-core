class Platformio < Formula
  include Language::Python::Virtualenv

  desc "Ecosystem for IoT development (Arduino and ARM mbed compatible)"
  homepage "https://platformio.org/"
  url "https://files.pythonhosted.org/packages/8c/d0/99da2ec4a2f0f2ca3a6122a29c20a8157fcfffabce2e4227744f9cb3e5d6/platformio-3.6.3.tar.gz"
  sha256 "5b339df778f846392e37b49d98a44ef561425ba811a1e51c2b2e1b4445e3ce03"

  bottle do
    cellar :any_skip_relocation
    sha256 "bdb18084a2a896b4dcc7c74d6d6b504689aaf79534b6bc6b62fcf1a907e43450" => :mojave
    sha256 "f990fe4a8eefdf3a977cc6f0d51aafea1eb083c489d0cb8323c7a7ae659ca65f" => :high_sierra
    sha256 "7778f23ff5aafe0ffe55b6ab60c50b51035590794998c18eda32bd579e4aa845" => :sierra
  end

  depends_on "python@2" # does not support Python 3

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/38/6d/593c8338851a249c9981322bab2bcffade1101127dce27d4c682ed234558/bottle-0.12.15.tar.gz"
    sha256 "b5529f8956682320b90f518041269784a37770d5fcc1ae6d70d288e9fc060fbc"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/55/54/3ce77783acba5979ce16674fc98b1920d00b01d337cfaaf5db22543505ed/certifi-2018.11.29.tar.gz"
    sha256 "47f9c83ef4c0c621eaef743f133f09fa8a74a9b75f037e8624f83bd1b6626cb7"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b7/34/a496632c4fb6c1ee76efedf77bb8d28b29363d839953d95095b12defe791/click-5.1.tar.gz"
    sha256 "678c98275431fad324275dec63791e4a17558b40e5a110e20a82866139a85a5a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/76/53/e785891dce0e2f2b9f4b4ff5bc6062a53332ed28833c7afede841f46a5db/colorama-0.4.1.tar.gz"
    sha256 "05eed71e2e327246ad6b38c540c4a3117230b19679b875190486ddd2d721422d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz"
    sha256 "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/cc/74/11b04703ec416717b247d789103277269d567db575d2fd88f25d9767fe3d/pyserial-3.4.tar.gz"
    sha256 "6e2d401fdee0eab996cf734e67773a0143b932772ca8b42451440cfed942c627"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/52/2c/514e4ac25da2b08ca5a464c50463682126385c4272c18193876e91f4bc38/requests-2.21.0.tar.gz"
    sha256 "502a824f31acdacb3a35b6690b5fbf0bc41d63a24a45c4004352b0242707598e"
  end

  resource "semantic_version" do
    url "https://files.pythonhosted.org/packages/72/83/f76958017f3094b072d8e3a72d25c3ed65f754cc607fdb6a7b33d84ab1d5/semantic_version-2.6.0.tar.gz"
    sha256 "2a4328680073e9b243667b201119772aefc5fc63ae32398d6afafff07c4f54c0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b1/53/37d82ab391393565f2f831b8eedbffd57db5a718216f82f1a8b4d381a1c1/urllib3-1.24.1.tar.gz"
    sha256 "de9529817c93f27c8ccbfead6985011db27bd0ddfcdb2d86f3f663385c6a9c22"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"platformio"
    system bin/"pio"
    system bin/"piodebuggdb", "--help"
  end
end

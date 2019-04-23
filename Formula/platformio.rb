class Platformio < Formula
  include Language::Python::Virtualenv

  desc "Ecosystem for IoT development (Arduino and ARM mbed compatible)"
  homepage "https://platformio.org/"
  url "https://files.pythonhosted.org/packages/dc/19/b92d62fdb3937f9f46ed833e27005923949a960fa3fe78185d4f3549bd09/platformio-3.6.7.tar.gz"
  sha256 "eb698b93bfc06010a2a210aacadc5d08efd4f05fe5494eaf171ef54618cead36"

  bottle do
    cellar :any_skip_relocation
    sha256 "6d1fa7bdef8f24a00600c6b7eb6a967d4637bed54ec9255a69d135c6fe9af518" => :mojave
    sha256 "272763e8f7e0cfe50f1e285dc09a60d6098c27a23b76511bb29392ca28c9e878" => :high_sierra
    sha256 "8639dbd46f38d95abdc482d9e380eeefbc679ed290b0e5e5090a0dde8fc8864e" => :sierra
  end

  depends_on "python@2" # does not support Python 3

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/32/4e/ed046324d5ec980c252987c1dca191e001b9f06ceffaebf037eef469937c/bottle-0.12.16.tar.gz"
    sha256 "9c310da61e7df2b6ac257d8a90811899ccb3a9743e77e947101072a2e3186726"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/06/b8/d1ea38513c22e8c906275d135818fee16ad8495985956a9b7e2bb21942a1/certifi-2019.3.9.tar.gz"
    sha256 "b26104d6835d1f5e49452a26eb2ff87fe7090b89dfcaee5ea2212697e1e1d7ae"
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
    url "https://files.pythonhosted.org/packages/fd/fa/b21f4f03176463a6cccdb612a5ff71b927e5224e83483012747c12fc5d62/urllib3-1.24.2.tar.gz"
    sha256 "9a247273df709c4fedb38c711e44292304f73f39ab01beda9f6b9fc375669ac3"
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

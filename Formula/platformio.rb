class Platformio < Formula
  include Language::Python::Virtualenv

  desc "An open-source ecosystem for embedded development"
  homepage "https://platformio.org/"
  url "https://files.pythonhosted.org/packages/15/58/49a7134412731bd585f996d9c69e70f7eff0bacf795a7a55524dadf412cd/platformio-4.3.1.tar.gz"
  sha256 "fa36a8ba1a321709d0bbc37f76e8c763eee8d5a06f8f01375cd79c7b56f1e919"

  bottle do
    cellar :any_skip_relocation
    sha256 "57fd95ebc84ab37a3ac4d52d6c7bc7f27c9f26231baf4032237121db939ea822" => :catalina
    sha256 "5479db901ef6a541b9337b481fa5d0487c4dfbee8271de20a8d057642d1148cb" => :mojave
    sha256 "64bdeec13390cef81ea0f6cf32b67ddda2c811320daa77b2c1d20a5b2f087c07" => :high_sierra
  end

  depends_on "python@3.8"

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/d9/4f/57887a07944140dae0d039d8bc270c249fc7fc4a00744effd73ae2cde0a9/bottle-0.12.18.tar.gz"
    sha256 "0819b74b145a7def225c0e83b16a4d5711fde751cd92bae467a69efce720f69e"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/41/bf/9d214a5af07debc6acf7f3f257265618f1db242a3f8e49a9b516f24523a6/certifi-2019.11.28.tar.gz"
    sha256 "25b64c7da4cd7479594d035c08c2d809eb4aab3a26e5a990ea98cc450c320f1f"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/4e/ab/5d6bc3b697154018ef196f5b17d958fac3854e2efbc39ea07a284d4a6a9b/click-7.1.1.tar.gz"
    sha256 "8a18b4ea89d8820c5d0c7da8a64b2c324b4dabb695804dbfea19b9be9d88c0cc"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/82/75/f2a4c0c94c85e2693c229142eb448840fba0f9230111faa889d1f541d12d/colorama-0.4.3.tar.gz"
    sha256 "e96da0d330793e2cb9485e9ddfd918d456036c7149416295932478192f4436a1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cb/19/57503b5de719ee45e83472f339f617b0c01ad75cba44aba1e4c97c2b0abd/idna-2.9.tar.gz"
    sha256 "7588d1c14ae4c77d74036e8c22ff447b26d0fde8f007354fd48a7814db15b7cb"
  end

  resource "marshmallow" do
    url "https://files.pythonhosted.org/packages/a8/74/5aa84008ddc6e8fee93d961a9f04a745a349ad197d95ab89723c097b330d/marshmallow-3.5.1.tar.gz"
    sha256 "90854221bbb1498d003a0c3cc9d8390259137551917961c8b5258c64026b2f85"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/9e/0f/82583ae6638a23e416cb3f15e3e3c07af51725fe51a4eaf91ede265f4af9/pyelftools-0.26.tar.gz"
    sha256 "86ac6cee19f6c945e8dedf78c6ee74f1112bd14da5a658d8c9d4103aed5756a2"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/cc/74/11b04703ec416717b247d789103277269d567db575d2fd88f25d9767fe3d/pyserial-3.4.tar.gz"
    sha256 "6e2d401fdee0eab996cf734e67773a0143b932772ca8b42451440cfed942c627"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/f5/4f/280162d4bd4d8aad241a21aecff7a6e46891b905a4341e7ab549ebaf7915/requests-2.23.0.tar.gz"
    sha256 "b3f43d496c6daba4493e7c431722aeb7dbc6288f52a6e04e7b6023b0247817e6"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/67/24/7e8fcb6aa88bfc018f8e4c48c4dbc8e87d8c7b3c0d0d8b3b0c61a34d32c7/semantic_version-2.8.4.tar.gz"
    sha256 "352459f640f3db86551d8054d1288608b29a96e880c7746f0a59c92879d412a3"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/c4/41/523f6a05e6dc3329a5660f6a81254c6cd87e5cfb5b7482bae3391d86ec3a/tabulate-0.8.6.tar.gz"
    sha256 "5470cc6687a091c7042cee89b2946d9235fe9f6d49c193a4ae2ac7bf386737c8"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/09/06/3bc5b100fe7e878d3dee8f807a4febff1a40c213d2783e3246edde1f3419/urllib3-1.25.8.tar.gz"
    sha256 "87716c2d2a7121198ebcb7ce7cccf6ce5e9ba539041cfbaeecfb641dc0bf6acc"
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

class Platformio < Formula
  include Language::Python::Virtualenv

  desc "Ecosystem for IoT development (Arduino and ARM mbed compatible)"
  homepage "http://platformio.org"
  url "https://pypi.python.org/packages/01/29/5720a510593527335710a6f0219d7e7cff177d799cfeb61a74e2a2e94f84/platformio-3.2.1.tar.gz"
  sha256 "fad4b32bc68f44ac0df7582d2965be456012bd79bb6c220797155d220c503d17"

  bottle do
    cellar :any_skip_relocation
    sha256 "991ae3c2f9885133ffac704cccb1b9a972bb87d3323de135d95ade336330bf37" => :sierra
    sha256 "f7c3dfb4f492afeda3f5382509e89686b2c9d38d7c2d98ee32ce00340d32ffaa" => :el_capitan
    sha256 "c46726959dbe80539200bdb84fb750e351a48e952a630ec0e6c04bf8ada52855" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/32/3c/e853a68b703f347f5ed86585c2dd2828a83252e1216c1201fa6f81270578/setuptools-26.1.1.tar.gz"
    sha256 "475ce28993d7cb75335942525b9fac79f7431a7f6e8a0079c0f2680641379481"
  end

  resource "bottle" do
    url "https://pypi.python.org/packages/7e/b5/a8404cf922bdedb63b41e9b6f3ae64c93f99cf1accdf0fc265ae75f063a2/bottle-0.12.10.tar.gz"
    sha256 "1308133647adc2d266f0ba5fea6684ba955cbf5e8133590cf0314c8beb814ff4"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b7/34/a496632c4fb6c1ee76efedf77bb8d28b29363d839953d95095b12defe791/click-5.1.tar.gz"
    sha256 "678c98275431fad324275dec63791e4a17558b40e5a110e20a82866139a85a5a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/f0/d0/21c6449df0ca9da74859edc40208b3a57df9aca7323118c913e58d442030/colorama-0.3.7.tar.gz"
    sha256 "e043c8d32527607223652021ff648fbb394d5e19cba9f1a698670b338c9d782b"
  end

  resource "lockfile" do
    url "https://files.pythonhosted.org/packages/17/47/72cb04a58a35ec495f96984dddb48232b551aafb95bde614605b754fe6f7/lockfile-0.12.2.tar.gz"
    sha256 "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799"
  end

  resource "pyserial" do
    url "https://pypi.python.org/packages/1f/3b/ee6f354bcb1e28a7cd735be98f39ecf80554948284b41e9f7965951befa6/pyserial-3.2.1.tar.gz"
    sha256 "1eecfe4022240f2eab5af8d414f0504e072ee68377ba63d3b6fe6e66c26f66d1"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/2e/ad/e627446492cc374c284e82381215dcd9a0a87c4f6e90e9789afefe6da0ad/requests-2.11.1.tar.gz"
    sha256 "5acf980358283faba0b897c73959cecf8b841205bb4b2ad3ef545f46eae1a133"
  end

  resource "semantic_version" do
    url "https://pypi.python.org/packages/72/83/f76958017f3094b072d8e3a72d25c3ed65f754cc607fdb6a7b33d84ab1d5/semantic_version-2.6.0.tar.gz"
    sha256 "2a4328680073e9b243667b201119772aefc5fc63ae32398d6afafff07c4f54c0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"platformio"
    system bin/"pio"
  end
end

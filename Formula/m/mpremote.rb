class Mpremote < Formula
  include Language::Python::Virtualenv

  desc "Tool for interacting remotely with MicroPython devices"
  homepage "https://docs.micropython.org/en/latest/reference/mpremote.html"
  url "https://files.pythonhosted.org/packages/d2/1c/be7d96275379eca70af111a1d4711c77b1afa78f1782582f3ad082e2d228/mpremote-1.27.0.tar.gz"
  sha256 "6bb75774648091dad6833af4f86c5bf6505f8d7aec211380f9e6996c01d23cb5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a2e5c6424a4903b4b5e8fa38bfd7973c0686b06a51c93b0c0d149ac441fd6ec7"
  end

  depends_on "python@3.14"

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/61/33/9611380c2bdb1225fdef633e2a9610622310fed35ab11dac9620972ee088/platformdirs-4.5.0.tar.gz"
    sha256 "70ddccdd7c99fc5942e9fc25636a8b34d04c24b335100223152c2803e4063312"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mpremote --version")
    assert_match "no device found", shell_output("#{bin}/mpremote soft-reset 2>&1", 1)
  end
end

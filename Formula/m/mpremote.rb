class Mpremote < Formula
  include Language::Python::Virtualenv

  desc "Tool for interacting remotely with MicroPython devices"
  homepage "https://docs.micropython.org/en/latest/reference/mpremote.html"
  url "https://files.pythonhosted.org/packages/9c/ff/e54b17cb43b1b81a4267de73079b964f4bccf7762039e7c3fb12db21294a/mpremote-1.26.1.tar.gz"
  sha256 "61a39bf5af502e1ec56d1b28bf067766c3a0daea9d7487934cb472e378a12fe1"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "a6a6ab50ab0bdcaa6d06c55017b1ff413a6b073d50b125c0c3c0fca607991638"
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

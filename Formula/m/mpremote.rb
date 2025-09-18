class Mpremote < Formula
  include Language::Python::Virtualenv

  desc "Tool for interacting remotely with MicroPython devices"
  homepage "https://docs.micropython.org/en/latest/reference/mpremote.html"
  url "https://files.pythonhosted.org/packages/9c/ff/e54b17cb43b1b81a4267de73079b964f4bccf7762039e7c3fb12db21294a/mpremote-1.26.1.tar.gz"
  sha256 "61a39bf5af502e1ec56d1b28bf067766c3a0daea9d7487934cb472e378a12fe1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2cdcd742ef8a31e9c56af15b9d9e2a214519297efc8a8bdb86863f5aa2e8e12f"
  end

  depends_on "python@3.13"

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/23/e8/21db9c9987b0e728855bd57bff6984f67952bea55d6f75e055c46b5383e8/platformdirs-4.4.0.tar.gz"
    sha256 "ca753cf4d81dc309bc67b0ea38fd15dc97bc30ce419a7f58d13eb3bf14c4febf"
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

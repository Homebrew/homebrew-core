class Mpremote < Formula
  include Language::Python::Virtualenv

  desc "Tool for interacting remotely with MicroPython devices"
  homepage "https://docs.micropython.org/en/latest/reference/mpremote.html"
  url "https://files.pythonhosted.org/packages/ac/b7/8c44eb606b0e53517fd6ddda3f598b3bdb180c181f4e0bcbb9b7743f4cb5/mpremote-1.29.0.tar.gz"
  sha256 "ab0b6f21059698e573ca076fe9a0299e5fe7bbc3ca3f5b2f00007e22e51c7b80"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "49b6be298f88e70fd9a774d8183d8fff665e0662bbd26a770484fab17811b373"
  end

  depends_on "python@3.14"

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/50/bb/ebc6636e1ae41314f796ebb7215fd28febb45f9aac72f2b04cb74b5071dc/platformdirs-4.11.4.tar.gz"
    sha256 "f3373be828247211d0febabea97e238c3dfde8a60b3c90c32756fb52cb21556d"
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

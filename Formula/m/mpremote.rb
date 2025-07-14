class Mpremote < Formula
  include Language::Python::Virtualenv

  desc "Tool for interacting remotely with MicroPython devices"
  homepage "https://docs.micropython.org/en/latest/reference/mpremote.html"
  url "https://files.pythonhosted.org/packages/86/1d/4a194eb385133349954cbf269e673e59e28b9510c7805e955da1cd32f4c6/mpremote-1.25.0.tar.gz"
  sha256 "d0dcd8ab364d87270e1766308882e536e541052efd64aadaac83bc7ebbea2815"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e0a64c3be9447ab462935ea95ed2d722264aadb1bd24146710393b5a6ef81d19"
  end

  depends_on "python@3.13"

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

class Cc3200tool < Formula
  include Language::Python::Virtualenv

  desc "Small tool to write files in TI's CC3200"
  homepage "https://github.com/toniebox-reverse-engineering/cc3200tool"
  url "https://github.com/toniebox-reverse-engineering/cc3200tool/archive/refs/tags/v1.2.2.tar.gz",
      verified: "github.com/toniebox-reverse-engineering/cc3200tool/"
  sha256 "ba33ce0056755a771e639184fc533aaebc3307cf2ef2d75d3539921a0858952f"
  license "GPL-2.0-only"

  depends_on "python@3.12"

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/cc3200tool --help")
    assert_match "usage: cc3200tool [-h] [-p PORT] [-if IMAGE_FILE] [-of OUTPUT_FILE]\n", output
  end
end

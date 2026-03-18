class Envycontrol < Formula
  include Language::Python::Virtualenv

  desc "Easy GPU switching for Nvidia Optimus laptops under Linux"
  homepage "https://github.com/bayasdev/envycontrol"
  url "https://github.com/bayasdev/envycontrol/archive/refs/tags/v3.5.2.tar.gz"
  sha256 "c0a4127ab967ab99308b157de864bd1957d4ad2ac13bc4197e9cda5f381f5a41"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"envycontrol", "--help"
  end
end

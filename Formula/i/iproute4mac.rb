class Iproute4mac < Formula
  include Language::Python::Virtualenv

  desc "CLI wrapper for iproute2 Linux routing utilities"
  homepage "https://pypi.org/project/iproute4mac/"
  url "https://files.pythonhosted.org/packages/cd/32/b344b2fc63a870b31e6ffc4e652cab186689441daba80e0a62eca4b25bb0/iproute4mac-0.4.1.tar.gz"
  sha256 "05b07c3aa531967b3b51f23b490c4f81fffd36cf8d406cf7caf95d6356023799"
  license "Apache-2.0"

  depends_on :macos
  depends_on "python@3.12"

  conflicts_with "iproute2mac", because: "both provide same executables"

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/ip addr").strip
    assert_match "link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00", output
  end
end

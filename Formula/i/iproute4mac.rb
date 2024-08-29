class Iproute4mac < Formula
  include Language::Python::Virtualenv

  desc "CLI wrapper for iproute2 Linux routing utilities"
  homepage "https://pypi.org/project/iproute4mac/"
  url "https://files.pythonhosted.org/packages/fc/b3/31749bf2ffff2b7eaf20fd8e03430354e9dbfcefc53894a4367aae297c47/iproute4mac-0.4.0.tar.gz"
  sha256 "a02253fffb4debea3e2bd493aecbc0881fe8357afa32418ee0d4b13db9d7c949"
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

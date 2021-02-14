class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek file sharing network"
  homepage "https://nicotine-plus.github.io/nicotine-plus/"
  url "https://files.pythonhosted.org/packages/f1/e6/818eb82e9cfe93dcdd769bfe111869a971fb94c2ca7fedbfd44236f9c676/nicotine-plus-3.0.0.tar.gz"
  sha256 "814d7b8c9a07d211a0b36b21a5b075f38db3840aaae26dd2acd42ac90b71cc60"
  license "GPL-3.0-or-later"
  head "https://github.com/Nicotine-Plus/nicotine-plus.git"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "284ab0e4d1fdfc9bab0c6478ed2c354c1f047f39d0658f1b073dd2a9a37b84ce"
    sha256 cellar: :any_skip_relocation, big_sur:       "c6b26f5e472d343bd5f6190af50d15326df5d4b249c973bb997de195d7af26fa"
    sha256 cellar: :any_skip_relocation, catalina:      "f03e6e761f7a8062d506738b544762e89a020f626d8ba154b7c838a44dbd5af4"
    sha256 cellar: :any_skip_relocation, mojave:        "52431db05bd1e9c96594a8e1168c9e3645c53f582df85841d5e04ddf5b8bc1dd"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nicotine -v")
    pid = fork do
      exec bin/"nicotine", "-s"
    end
    sleep 3
    Process.kill("TERM", pid)
  end
end

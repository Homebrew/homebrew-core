class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek file sharing network"
  homepage "https://nicotine-plus.github.io/nicotine-plus/"
  url "https://files.pythonhosted.org/packages/ca/10/5c244a661fdc18e5ddfa9eaec244fb6fdd4f7e77a125636907851185b0a7/nicotine-plus-3.2.7.tar.gz"
  sha256 "39ee271ee6eb86c6abaad3f0b33332bf78be6cf270245a2f53a4760735007f32"
  license "GPL-3.0-or-later"
  head "https://github.com/Nicotine-Plus/nicotine-plus.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e55ebcb6bcf83863697441a0a689ff912970674e9689e856cfab545aa9271093"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e55ebcb6bcf83863697441a0a689ff912970674e9689e856cfab545aa9271093"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e55ebcb6bcf83863697441a0a689ff912970674e9689e856cfab545aa9271093"
    sha256 cellar: :any_skip_relocation, ventura:        "5a08281e6ac89a6eaefecef2ef1950b0f2792350b939791ae088d50130808d79"
    sha256 cellar: :any_skip_relocation, monterey:       "5a08281e6ac89a6eaefecef2ef1950b0f2792350b939791ae088d50130808d79"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a08281e6ac89a6eaefecef2ef1950b0f2792350b939791ae088d50130808d79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06c399bb9b2c23aa5509f3897b52bae5266d39e7fe4ce3369c06223729b2256c"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.11"

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

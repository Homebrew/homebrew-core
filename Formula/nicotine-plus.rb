class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek file sharing network"
  homepage "https://nicotine-plus.github.io/nicotine-plus/"
  url "https://files.pythonhosted.org/packages/25/76/9ef26b9311b8a475d15a4173789a463fa9dc28cff0d11e9d3edd34da3889/nicotine-plus-3.2.0.tar.gz"
  sha256 "aca21de8596a81a54fdd306b5e1338fd530e94c983e01425dcaf48e6e1395785"
  license "GPL-3.0-or-later"
  head "https://github.com/Nicotine-Plus/nicotine-plus.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5219c66ab06bc074d62a61bafd3f7015eba1c25669486e72ff5f5be41e65e89b"
    sha256 cellar: :any_skip_relocation, monterey:      "bed26c3ce94e722926ceb92abeac55c749aa37871753c778f1ded8b60f35ec0b"
    sha256 cellar: :any_skip_relocation, big_sur:       "1224468b0308e86859ed06db5095b465864cb189320bef6e3108b55da28d1f94"
    sha256 cellar: :any_skip_relocation, catalina:      "1224468b0308e86859ed06db5095b465864cb189320bef6e3108b55da28d1f94"
    sha256 cellar: :any_skip_relocation, mojave:        "1224468b0308e86859ed06db5095b465864cb189320bef6e3108b55da28d1f94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c92328243c9d71cc5f1b494a20a8e2ed21ddf97c42c3433c7c681a9586d354f"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "py3cairo"
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

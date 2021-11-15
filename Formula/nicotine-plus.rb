class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek file sharing network"
  homepage "https://nicotine-plus.github.io/nicotine-plus/"
  url "https://files.pythonhosted.org/packages/ee/2d/d8fcc06fb78a294fbc399568fcec4a706c31a681b94ba25b009c8a4377cf/nicotine-plus-3.1.1.tar.gz"
  sha256 "ce8342fcbc4d6fd50b9c29465eaca45d35c8c7be0a3ef03f5c1d9a594d96ec34"
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

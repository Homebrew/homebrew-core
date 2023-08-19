class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek peer-to-peer network"
  homepage "https://nicotine-plus.org"
  url "https://files.pythonhosted.org/packages/70/d5/15d8c60e3d27d3482fb8cba3ae0c49e57efe00f28e51b8aaea09f979bc48/nicotine-plus-3.2.9.tar.gz"
  sha256 "41a86dc68b175d1dcac2ec2d79553cff4e5fbcca7f9f384c51cbaa393081b0c0"
  license "GPL-3.0-or-later"
  head "https://github.com/nicotine-plus/nicotine-plus.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dae22739f46074ff222fb8b6a132f4e2a7f671c40ac9c9661217160d675e5ea6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dae22739f46074ff222fb8b6a132f4e2a7f671c40ac9c9661217160d675e5ea6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dae22739f46074ff222fb8b6a132f4e2a7f671c40ac9c9661217160d675e5ea6"
    sha256 cellar: :any_skip_relocation, ventura:        "b6a2c3a40eef25cfe31c57bc010993e7bc91685c30d3f7c72e402b69b1c5b9a6"
    sha256 cellar: :any_skip_relocation, monterey:       "b6a2c3a40eef25cfe31c57bc010993e7bc91685c30d3f7c72e402b69b1c5b9a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6a2c3a40eef25cfe31c57bc010993e7bc91685c30d3f7c72e402b69b1c5b9a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5443bc6c67686123968bbf9ac266ee0ccbd8e95b962e1e5bf24c23e7fe32151d"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.11"

  on_linux do
    depends_on "gettext" => :build # for `msgfmt`
  end

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

class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek file sharing network"
  homepage "https://nicotine-plus.github.io/nicotine-plus/"
  url "https://files.pythonhosted.org/packages/8d/60/a0a7b9d9066a4edcc4b9965d71e31794fc5faf2f8624619d46a8c484d272/nicotine-plus-3.2.2.tar.gz"
  sha256 "32bb50559bb67b0b6d1760d4a11eec0660f841d00607a1f165292c967b6001c9"
  license "GPL-3.0-or-later"
  head "https://github.com/Nicotine-Plus/nicotine-plus.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50951fe4bde0d0d0acc2afd68767aa6b314bfe9dc3c091b1c0111265da9ae9a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50951fe4bde0d0d0acc2afd68767aa6b314bfe9dc3c091b1c0111265da9ae9a2"
    sha256 cellar: :any_skip_relocation, monterey:       "aaa6ec5dd1bd8bf311e0bd028e5cd257d8b80ec4eeef1a07481c9190fe7a928e"
    sha256 cellar: :any_skip_relocation, big_sur:        "aaa6ec5dd1bd8bf311e0bd028e5cd257d8b80ec4eeef1a07481c9190fe7a928e"
    sha256 cellar: :any_skip_relocation, catalina:       "aaa6ec5dd1bd8bf311e0bd028e5cd257d8b80ec4eeef1a07481c9190fe7a928e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d93c6488d5a87d0916a50f746e760600d1f5b6d483f34a97185b09d09889fa6"
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

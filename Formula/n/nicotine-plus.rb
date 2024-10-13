class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek peer-to-peer network"
  homepage "https://nicotine-plus.org"
  url "https://files.pythonhosted.org/packages/0e/73/ba597ab69a24106e0ba44eef0346116f37842b8273d357a46ad2d05cc729/nicotine_plus-3.3.5.tar.gz"
  sha256 "e0c9d650606a9f9eab8e5c2b7fd560ddb5cfe475ea4c22f19b833d7ebf86ba43"
  license "GPL-3.0-or-later"
  head "https://github.com/nicotine-plus/nicotine-plus.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0214a718bc6c2b9c4ea4e017ce586a8c0c23adc0f223b5ce32f1d96b75c3530"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0214a718bc6c2b9c4ea4e017ce586a8c0c23adc0f223b5ce32f1d96b75c3530"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d0214a718bc6c2b9c4ea4e017ce586a8c0c23adc0f223b5ce32f1d96b75c3530"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0214a718bc6c2b9c4ea4e017ce586a8c0c23adc0f223b5ce32f1d96b75c3530"
    sha256 cellar: :any_skip_relocation, ventura:       "d0214a718bc6c2b9c4ea4e017ce586a8c0c23adc0f223b5ce32f1d96b75c3530"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67745151b15f23707214562a009840c9d64c133e8c22f48fc04774beafa1de85"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk4"
  depends_on "libadwaita"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.12"

  on_linux do
    depends_on "gettext" => :build # for `msgfmt`
  end

  conflicts_with "httm", because: "both install `nicotine` binaries"

  def install
    virtualenv_install_with_resources
  end

  test do
    # nicotine is a GUI app
    assert_match version.to_s, shell_output("#{bin}/nicotine --version")
  end
end

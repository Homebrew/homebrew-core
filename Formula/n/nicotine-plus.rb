class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek peer-to-peer network"
  homepage "https://nicotine-plus.org"
  url "https://files.pythonhosted.org/packages/63/1c/73f765da20b5b7e3579f6099490a9c4ac93e7c6341f97cf51d53ea0df49f/nicotine_plus-3.3.4.tar.gz"
  sha256 "512bf4aea9b42d5f3d58e0c96ed90efc2af568f8d0a624bf957ffb5f84ab9b7c"
  license "GPL-3.0-or-later"
  head "https://github.com/nicotine-plus/nicotine-plus.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8875a029414bce7161995b77acebd7428ac52377652f33b01c78abe3bd746e7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d162a33ead1588f3f2c76a0c67428fa22700c558c1f1df98dbee583993d8f5a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee522ad1fa32ef1800cbbb9a8e8ea32a12a23bed002a69f5c3e5a10b6e716db6"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe2004205d8e0916da6a8936e122f97d53ee8b59753eec0c76a999d66b028696"
    sha256 cellar: :any_skip_relocation, ventura:        "3b8d4635c4df181dc7ae33c0eff03f565464463bde47e12a919229fa6436c398"
    sha256 cellar: :any_skip_relocation, monterey:       "d8a0fc775bc5639e552c5e737b8181def514fbe36d48dee09e0956f4f46a8c2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06ede68cd7aa99ae21ea6128872b9730852a9a292993ba03d4afb0507ffa0a58"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python-gdbm@3.12"
  depends_on "python@3.12"

  on_linux do
    depends_on "gettext" => :build # for `msgfmt`
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # nicotine is a GUI app
    assert_match version.to_s, shell_output("#{bin}/nicotine --version")
  end
end

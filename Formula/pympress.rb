class Pympress < Formula
  include Language::Python::Virtualenv

  desc "Simple and powerful dual-screen PDF reader designed for presentations"
  homepage "https://github.com/Cimbali/pympress/"
  url "https://files.pythonhosted.org/packages/df/e2/505d85316e07aa2a641cf88460a2bb0ac0eac26462e87b98993a08b1e639/pympress-1.6.2.tar.gz"
  sha256 "70b6933dda56e2ed300d257777ae0ced2964dbb9dab7dc3e25abd8d7abe3b56c"
  license "GPL-2.0-or-later"
  head "https://github.com/Cimbali/pympress.git"

  bottle do
    sha256 cellar: :any, big_sur:  "dcf74c6df97e8eeda3a9a9b98aaf6ff48d7256a9f188693c84e396529c2f103d"
    sha256 cellar: :any, catalina: "e18b08d0632cbcc4fcb041cffed78e3c4d24c30a1f158be74e0a4eeeb7ffffb5"
    sha256 cellar: :any, mojave:   "dca884e4a3a106e65b72c878a7444706005eeac196b9a5eba2299a3a128b9f18"
  end

  depends_on "gobject-introspection"
  depends_on "gtk+3"
  depends_on "libyaml"
  depends_on "poppler"
  depends_on "pygobject3"
  depends_on "python@3.9"

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/f5/c2/d1ff8343cd38138561d2f08aba7b0566020485346097019f3a87773c96fc/watchdog-2.1.3.tar.gz"
    sha256 "e5236a8e8602ab6db4b873664c2d356c365ab3cac96fbdec4970ad616415dd45"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/pympress"
  end

  test do
    on_linux do
      # (pympress:48790): Gtk-WARNING **: 13:03:37.080: cannot open display
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    system bin/"pympress", "--quit"
  end
end

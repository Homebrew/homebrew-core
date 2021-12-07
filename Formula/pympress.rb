class Pympress < Formula
  include Language::Python::Virtualenv

  desc "Simple and powerful dual-screen PDF reader designed for presentations"
  homepage "https://github.com/Cimbali/pympress/"
  url "https://files.pythonhosted.org/packages/3f/33/56f8e84cc3079f866d8b3fdd2d9ef538fab7a9a0cfc7b0e02c5cf65b95fb/pympress-1.7.1.tar.gz"
  sha256 "bfdc228cb14862dba943abf9ece92d9e966c433e566ba514985739966f838ee3"
  license "GPL-2.0-or-later"
  head "https://github.com/Cimbali/pympress.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey: "5df4896f9b20b957a56c2ca01aa97004420b3bb27ecb6752cedc938c132cbdea"
    sha256 cellar: :any_skip_relocation, big_sur:  "d6a7c28f5b145de3054cbfcfe94999ca1dd0401d01092da0b5a56bc9af72f504"
    sha256 cellar: :any_skip_relocation, catalina: "414c138633730609b93f975065f2528d63afae3cca4431479644b392b74a4f4b"
  end

  depends_on "gobject-introspection"
  depends_on "gst-plugins-bad"
  depends_on "gst-plugins-base"
  depends_on "gst-plugins-good"
  depends_on "gst-plugins-ugly"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "libyaml"
  depends_on "poppler"
  depends_on "pygobject3"
  depends_on "python@3.9"

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/e8/a8/fc4edd7d768361b00ea850e5310211d157df6b5a1db6148dd434e787d898/watchdog-2.1.6.tar.gz"
    sha256 "a36e75df6c767cbf46f61a91c70b3ba71811dfa0aca4a324d9407a06a8b7a2e7"
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

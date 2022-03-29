class Pympress < Formula
  include Language::Python::Virtualenv

  desc "Simple and powerful dual-screen PDF reader designed for presentations"
  homepage "https://github.com/Cimbali/pympress/"
  url "https://files.pythonhosted.org/packages/3f/33/56f8e84cc3079f866d8b3fdd2d9ef538fab7a9a0cfc7b0e02c5cf65b95fb/pympress-1.7.1.tar.gz"
  sha256 "bfdc228cb14862dba943abf9ece92d9e966c433e566ba514985739966f838ee3"
  license "GPL-2.0-or-later"
  head "https://github.com/Cimbali/pympress.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey: "269509fc2d58e1d0319bb0799556287b57d4d25e5a7e2481d70a3ebc70dd27bf"
    sha256 cellar: :any_skip_relocation, big_sur:  "ead363489a8fbe39769636a5e5acf5ccc062daa5fc83d4ec27e6218c595faae6"
    sha256 cellar: :any_skip_relocation, catalina: "99da6a30b038eccc64d69c514f0c6e60212389bac7e6c2ba94f86d8089484154"
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
    # (pympress:48790): Gtk-WARNING **: 13:03:37.080: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"pympress", "--quit"
  end
end

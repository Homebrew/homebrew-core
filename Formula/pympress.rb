class Pympress < Formula
  include Language::Python::Virtualenv

  desc "Simple and powerful dual-screen PDF reader designed for presentations"
  homepage "https://github.com/Cimbali/pympress/"
  url "https://files.pythonhosted.org/packages/9b/69/9b60fab9cddc63ea11d3d16d07dc375951015cf2f360af1dbca2fff7fe15/pympress-1.6.3.tar.gz"
  sha256 "7fe3a3134c7fdf27c960708b07ea27ed34fb309daf36ef3b487462ebba850c23"
  license "GPL-2.0-or-later"
  head "https://github.com/Cimbali/pympress.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "d23e94203938b9d59f818dec35e88d80bf66fe166578287fafad6b5739b58261"
    sha256 cellar: :any_skip_relocation, catalina: "37212a6eb034ba941c1ad102504687e22f115d4629dd629c156449fe3b22a9cd"
    sha256 cellar: :any_skip_relocation, mojave:   "0f9e466b229aca78d61beab31c3bcea13641f7b367ac680d4b19716bbe1561da"
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

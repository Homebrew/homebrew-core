class Pympress < Formula
  include Language::Python::Virtualenv

  desc "Simple and powerful dual-screen PDF reader designed for presentations"
  homepage "https://github.com/Cimbali/pympress/"
  url "https://files.pythonhosted.org/packages/30/15/076cbcb2fcd828da499db28bda2699bdadc73c16953c564fee6e3b6c28c8/pympress-1.6.4.tar.gz"
  sha256 "f84b9dc4da0defab1dc3c39ba91837f51af7837b775194f0057d0045c8d2b04f"
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
    url "https://files.pythonhosted.org/packages/c5/e9/fb0f9775c82b4df1815bb97ebac13383adddff4cf014aceefb7c02262675/watchdog-2.1.5.tar.gz"
    sha256 "5563b005907613430ef3d4aaac9c78600dd5704e84764cb6deda4b3d72807f09"
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

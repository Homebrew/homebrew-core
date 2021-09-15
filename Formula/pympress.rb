class Pympress < Formula
  include Language::Python::Virtualenv

  desc "Simple and powerful dual-screen PDF reader designed for presentations"
  homepage "https://github.com/Cimbali/pympress/"
  url "https://files.pythonhosted.org/packages/30/15/076cbcb2fcd828da499db28bda2699bdadc73c16953c564fee6e3b6c28c8/pympress-1.6.4.tar.gz"
  sha256 "f84b9dc4da0defab1dc3c39ba91837f51af7837b775194f0057d0045c8d2b04f"
  license "GPL-2.0-or-later"
  head "https://github.com/Cimbali/pympress.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "e676d43863f32308f8ceac376b28404d969d0657ddf72b9e913ca58969e663a9"
    sha256 cellar: :any_skip_relocation, catalina: "3e1d8520834e6e0b7306387a5777455daf1af13d17fbd39d3375eb253a2b1c74"
    sha256 cellar: :any_skip_relocation, mojave:   "ad9edde182f9457d972dddc82a24792ea1043b8ced0a3517d468656b4a28d359"
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

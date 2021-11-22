class Pympress < Formula
  include Language::Python::Virtualenv

  desc "Simple and powerful dual-screen PDF reader designed for presentations"
  homepage "https://github.com/Cimbali/pympress/"
  url "https://files.pythonhosted.org/packages/c0/65/041a4feb4d432edce8215703892eef5379d0d925c7f304332501c29ddfac/pympress-1.7.0.tar.gz"
  sha256 "0311f43f2016604108a90031f601b6798c973228cb64666a5e446195ddf689e1"
  license "GPL-2.0-or-later"
  head "https://github.com/Cimbali/pympress.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey: "a3b2a3589a369d2ac4289d4702d667e14bfe0718bb183f057891d5f979ee3c96"
    sha256 cellar: :any_skip_relocation, big_sur:  "e676d43863f32308f8ceac376b28404d969d0657ddf72b9e913ca58969e663a9"
    sha256 cellar: :any_skip_relocation, catalina: "3e1d8520834e6e0b7306387a5777455daf1af13d17fbd39d3375eb253a2b1c74"
    sha256 cellar: :any_skip_relocation, mojave:   "ad9edde182f9457d972dddc82a24792ea1043b8ced0a3517d468656b4a28d359"
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

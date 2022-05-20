class Pympress < Formula
  include Language::Python::Virtualenv

  desc "Simple and powerful dual-screen PDF reader designed for presentations"
  homepage "https://github.com/Cimbali/pympress/"
  url "https://files.pythonhosted.org/packages/f6/a0/93d92200dd3febe3c83fbf491a353aed2bb8199cfc22f3b684ea77cdbecf/pympress-1.7.2.tar.gz"
  sha256 "2c5533ac61ebf23994aa821c2a8902d203435665b51146658fd788f860f272f2"
  license "GPL-2.0-or-later"
  head "https://github.com/Cimbali/pympress.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ab969d6e68b811d59fec774c4d1286354f622da7f28b79a44be8a52197799f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2e83c0c8f7e2d0bdf92e96c165ab861862dc389568744f7b5d4ca4bff8d56dd"
    sha256 cellar: :any_skip_relocation, monterey:       "d9851f0c99410614009969db4f3eec9be23807dc278d6559cbf9750db4fb0018"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1c5bfa7090a6c1b7203597f0e744604f2f9c99c24ce34454a2898e26d08c3be"
    sha256 cellar: :any_skip_relocation, catalina:       "92dd534f96c7bad50daed8d695ee22af97a7033c65799e45da2ce3e8a5e819be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "090e9d8438bbb18499bd50d6cb872f172a38da49239a8cb810b2d6c07c895732"
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
    url "https://files.pythonhosted.org/packages/b3/d2/a04951838e0b0cea20aff5214109144e6869101818e7f90bf3b68ea2facf/watchdog-2.1.7.tar.gz"
    sha256 "3fd47815353be9c44eebc94cc28fe26b2b0c5bd889dafc4a5a7cbdf924143480"
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

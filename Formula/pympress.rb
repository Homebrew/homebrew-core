class Pympress < Formula
  include Language::Python::Virtualenv

  desc "Simple and powerful dual-screen PDF reader designed for presentations"
  homepage "https://github.com/Cimbali/pympress/"
  url "https://files.pythonhosted.org/packages/f6/a0/93d92200dd3febe3c83fbf491a353aed2bb8199cfc22f3b684ea77cdbecf/pympress-1.7.2.tar.gz"
  sha256 "2c5533ac61ebf23994aa821c2a8902d203435665b51146658fd788f860f272f2"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/Cimbali/pympress.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb706b6cc0981b97daed3da8ef4d91706f06d783216d41cdcce862cb3593f880"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0358890f1207e2b1c942879e76aef1f27dde25c7e8e7210b65b7038df84798ea"
    sha256 cellar: :any_skip_relocation, monterey:       "6c2f636c96df736d8f859a9f43b7a7fb7df8bf619ee3c4340199087be8b8a42a"
    sha256 cellar: :any_skip_relocation, big_sur:        "275a8a4123fcabd193e9f054c69bf4ba6f74a5537273114adce0463c26fb26ce"
    sha256 cellar: :any_skip_relocation, catalina:       "214402f0a35fac37cc7a563ce7224de750f32b69515334780c1aaf00198081fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "381e24b30713ddf630d52e7775fd03b7262ecbffa21e588eb1027e721f888ce4"
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
  depends_on "python@3.10"

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

class Pympress < Formula
  include Language::Python::Virtualenv

  desc "Simple and powerful dual-screen PDF reader designed for presentations"
  homepage "https://github.com/Cimbali/pympress/"
  url "https://files.pythonhosted.org/packages/f6/a0/93d92200dd3febe3c83fbf491a353aed2bb8199cfc22f3b684ea77cdbecf/pympress-1.7.2.tar.gz"
  sha256 "2c5533ac61ebf23994aa821c2a8902d203435665b51146658fd788f860f272f2"
  license "GPL-2.0-or-later"
  head "https://github.com/Cimbali/pympress.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e182e85a285464afff947ad42d25fccbeebfd802722c4c6668e610bb03c54165"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d73a5236bf39d3b088ed79701623775ba520e0c666999c21305c9781a182a800"
    sha256 cellar: :any_skip_relocation, monterey:       "269509fc2d58e1d0319bb0799556287b57d4d25e5a7e2481d70a3ebc70dd27bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "ead363489a8fbe39769636a5e5acf5ccc062daa5fc83d4ec27e6218c595faae6"
    sha256 cellar: :any_skip_relocation, catalina:       "99da6a30b038eccc64d69c514f0c6e60212389bac7e6c2ba94f86d8089484154"
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

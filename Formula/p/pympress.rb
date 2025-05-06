class Pympress < Formula
  include Language::Python::Virtualenv

  desc "Simple and powerful dual-screen PDF reader designed for presentations"
  homepage "https://github.com/Cimbali/pympress/"
  url "https://files.pythonhosted.org/packages/fb/e2/91827c485aae28d69f0b40c6d366b9f6eb96d8208a98af0345e0ade3fbbd/pympress-1.8.5.tar.gz"
  sha256 "29bd39115d05f254da993abba42d54a0e9187f4e2ce7c363324b15136c530bf6"
  license "GPL-2.0-or-later"
  head "https://github.com/Cimbali/pympress.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f316d72786b317ac5b21e31d01c8cef6127f1f7f7ce6b118daa135c92741c105"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0505c142b3daa22ce3e5ee1ddd0573e5181a86648a729922024f5fac4e1ab894"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8ce2f60ddac40de33cc031840e04394845868616a0eaa6a745cde325857c432c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f283e466751b2d7830e51cc7d443e548abf7b3d6f3052f019bf69c579af74760"
    sha256 cellar: :any_skip_relocation, ventura:       "b64e3e0efbad5aae12e6641c4f50feaac3b59a6904f52a48aa3e88324cd094c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1ef86cd9f32e930f359ab3ab6fc5edba54923183a019b36811076d16634da34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13ab4556e72e88102a4dbac70df1e885a231cf90a0a1ece7e60c9413ff782bec"
  end

  depends_on "gobject-introspection"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "libyaml"
  depends_on "poppler"
  depends_on "pygobject3"
  depends_on "python@3.13"

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/db/7d/7f3d619e951c88ed75c6037b246ddcf2d322812ee8ea189be89511721d54/watchdog-6.0.0.tar.gz"
    sha256 "9ddf7c82fda3ae8e24decda1338ede66e1c99883db93711d8fb941eaa2d8c282"
  end

  def install
    # Workaround for build failure with Setuptools 78
    # Issue ref: https://github.com/Cimbali/pympress/issues/332
    inreplace "pyproject.toml", '"setuptools>=42"', '"setuptools>=42,<78"'

    virtualenv_install_with_resources
  end

  test do
    # (pympress:48790): Gtk-WARNING **: 13:03:37.080: cannot open display
    ENV["PYMPRESS_HEADLESS_TEST"] = "1" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath/"Library/Preferences").mkpath

    system bin/"pympress", "--quit"
    sleep 5
    sleep 15 if OS.mac? && Hardware::CPU.intel?

    # Check everything ran fine at least until reporting the version string in the log file
    # which means all dependencies got loaded OK. Do not check actual version numbers as it breaks --HEAD tests.
    log = if OS.linux?
      Pathname.new(ENV["XDG_CACHE_HOME"] || (testpath/".cache"))/"pympress.log"
    else
      testpath/"Library/Logs/pympress.log"
    end
    assert_path_exists log
    assert_match "INFO:pympress.app:Pympress:", log.read
  end
end

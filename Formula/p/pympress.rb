class Pympress < Formula
  include Language::Python::Virtualenv

  desc "Simple and powerful dual-screen PDF reader designed for presentations"
  homepage "https://github.com/Cimbali/pympress/"
  url "https://files.pythonhosted.org/packages/fb/e2/91827c485aae28d69f0b40c6d366b9f6eb96d8208a98af0345e0ade3fbbd/pympress-1.8.5.tar.gz"
  sha256 "29bd39115d05f254da993abba42d54a0e9187f4e2ce7c363324b15136c530bf6"
  license "GPL-2.0-or-later"
  head "https://github.com/Cimbali/pympress.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69b9150080604dcea831794aba78f785ce6743ad41847f6e9bb90cf02356eaf7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca5aa79ede4a81614c5b486733e22d476edf9993d8d1f1871bc870320b4dd692"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75cad3e04e36900ff767e57e8a17f37cf07d571bba104443b50ba0d34e1530b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "74d1a9e816d885ca0bbb0641143aa0daf326778dd909f450fcd3e18e97db8ce6"
    sha256 cellar: :any_skip_relocation, ventura:        "49204cf7f3d5a4b81d29ba9087100660d1fd78bdfd00f56edca3a157011271e4"
    sha256 cellar: :any_skip_relocation, monterey:       "39c3d273f17f03ab27012d327e00c80e6866d084fffa22f27c82e9d934671ddb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa9926be82452150807a6a20f2726ef0a0ba5495f83d468cf335a52022cd0c3c"
  end

  depends_on "gobject-introspection"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "libyaml"
  depends_on "poppler"
  depends_on "pygobject3"
  depends_on "python@3.12"

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/95/a6/d6ef450393dac5734c63c40a131f66808d2e6f59f6165ab38c98fbe4e6ec/watchdog-3.0.0.tar.gz"
    sha256 "4d98a320595da7a7c5a18fc48cb633c2e73cda78f93cac2ef42d42bf609a33f9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # (pympress:48790): Gtk-WARNING **: 13:03:37.080: cannot open display
    ENV["PYMPRESS_HEADLESS_TEST"]="1" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath/"Library/Preferences").mkpath

    system bin/"pympress", "--quit"

    # Check everything ran fine at least until reporting the version string in the log file
    # which means all dependencies got loaded OK. Do not check actual version numbers as it breaks --HEAD tests.
    log = if OS.linux?
      Pathname.new(ENV["XDG_CACHE_HOME"] || (testpath/".cache"))/"pympress.log"
    else
      testpath/"Library/Logs/pympress.log"
    end
    assert_predicate log, :exist?
    assert_match "INFO:pympress.app:Pympress:", log.read
  end
end

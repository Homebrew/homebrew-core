class Pympress < Formula
  include Language::Python::Virtualenv

  desc "Simple and powerful dual-screen PDF reader designed for presentations"
  homepage "https://github.com/Cimbali/pympress/"
  url "https://files.pythonhosted.org/packages/08/3f/9fd254a40155c8f51b52b045f5df16a794d21d4c3dfeb8c5d379671e72f1/pympress-1.8.2.tar.gz"
  sha256 "d9587112ab08b1c97d8f9baccde2f666b4b6291bd22fcb376d27574301b2c179"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/Cimbali/pympress.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d8d24fedbc9224464fc9d917d689c2bb19385ab000a09b09f5ea786dfd994e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d20d02e3bef56547087422569b32199435a92b750232d8ab4edc8fdad7839ace"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92c82f00fea337c371715f3b5fe6a15a5884300a96e9ea34081e57d6e3d34dca"
    sha256 cellar: :any_skip_relocation, ventura:        "010b35a5b0020f1d6779339687acb956b108a02c5191554d91ab2264c5ee2899"
    sha256 cellar: :any_skip_relocation, monterey:       "63d3825e4e609f26ceab417db71b1a13dc740045f1acaad47f0a73f7f4ce535e"
    sha256 cellar: :any_skip_relocation, big_sur:        "9771e2fe41d256339abe9e1dbf7569ab932cb2aecd1bd34007879779117803a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bb664da1b976473e9f1e48769b40f0244b266d3be605d962be979c71e99e169"
  end

  depends_on "gobject-introspection"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "libyaml"
  depends_on "poppler"
  depends_on "pygobject3"
  depends_on "python@3.11"

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/95/a6/d6ef450393dac5734c63c40a131f66808d2e6f59f6165ab38c98fbe4e6ec/watchdog-3.0.0.tar.gz"
    sha256 "4d98a320595da7a7c5a18fc48cb633c2e73cda78f93cac2ef42d42bf609a33f9"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/pympress"
  end

  test do
    # (pympress:48790): Gtk-WARNING **: 13:03:37.080: cannot open display
    ENV["PYMPRESS_HEADLESS_TEST"]="1" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

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

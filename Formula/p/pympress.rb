class Pympress < Formula
  include Language::Python::Virtualenv

  desc "Simple and powerful dual-screen PDF reader designed for presentations"
  homepage "https://github.com/Cimbali/pympress/"
  url "https://files.pythonhosted.org/packages/17/65/ffd6b30dae047fab0d4b1bef14940f194f555e9b7b6fe1520a650233e6ca/pympress-1.8.4.tar.gz"
  sha256 "ddc9c21c6a0a517d204f3231d6484cf9bafac7dfa0f565e1dbc48b866f7d78de"
  license "GPL-2.0-or-later"
  head "https://github.com/Cimbali/pympress.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4aad20967579ed6336c439cd43479ee629f462457551ec1933fd48c522f95e73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c86e6d2e4dc15f051306fd163459262bec890dd5c92bb700544eb7068790496"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c18b1adf0fe81bcf0de1fcc3e4bfc1588daac39ec24549100196c8d20c72e09c"
    sha256 cellar: :any_skip_relocation, ventura:        "063caefab7d4550f34ce2b9691ad1952b062df9b9e022e4d630450a9683e5a2a"
    sha256 cellar: :any_skip_relocation, monterey:       "8a218b585ecec29f5db849f463af0362625127106bd038dd87284b5532e86845"
    sha256 cellar: :any_skip_relocation, big_sur:        "0962fbc7a213a9314e236e8deecc5bc6ebdb8bfbc6c77672772eab985ae6a367"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "183c35f48fff970202af2a6a501c7c3c715bd9a2c459f13659e0c7ab7719ccbe"
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

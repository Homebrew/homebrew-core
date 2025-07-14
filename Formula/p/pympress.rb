class Pympress < Formula
  include Language::Python::Virtualenv

  desc "Simple and powerful dual-screen PDF reader designed for presentations"
  homepage "https://github.com/Cimbali/pympress/"
  url "https://files.pythonhosted.org/packages/87/66/fb9f8f2975740ea8880de293eb16b543965387881c71ca323a00a5d77d8a/pympress-1.8.6.tar.gz"
  sha256 "243dc5dd225acd13fb6bae680e2de1816d521203b98a9cff588b66f141fffd9a"
  license "GPL-2.0-or-later"
  head "https://github.com/Cimbali/pympress.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64f35865fbde010d4e3de039977eec6bc1bbe6dabb19fca1f9c3f9da709e1593"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad170caf12af4322d5b0f819cdf13616af3d389de0400f157ac7638cce10fcff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ec3fed16c5ce89078a32c6b63d2f1c14753463ccfc5ec2a15d2d04f133714fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2674da110b3e8914940e4433d6a2be31235f1ebd87e6511d5365e0fda822b8f"
    sha256 cellar: :any_skip_relocation, ventura:       "4bddb67288e852dd28024c0f2d850f09f7c26c4becf42aa4701e0e4904579e7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0bc4386fb18cdbfb144e8ffb7d532a55eacee02a76540260f5ccda0e7104e06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0bc4386fb18cdbfb144e8ffb7d532a55eacee02a76540260f5ccda0e7104e06"
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
    virtualenv_install_with_resources
  end

  test do
    # (pympress:48790): Gtk-WARNING **: 13:03:37.080: cannot open display
    ENV["PYMPRESS_HEADLESS_TEST"] = "1" if ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath/"Library/Preferences").mkpath

    system bin/"pympress", "--quit"

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

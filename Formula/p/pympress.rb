class Pympress < Formula
  include Language::Python::Virtualenv

  desc "Simple and powerful dual-screen PDF reader designed for presentations"
  homepage "https://github.com/Cimbali/pympress/"
  url "https://files.pythonhosted.org/packages/87/66/fb9f8f2975740ea8880de293eb16b543965387881c71ca323a00a5d77d8a/pympress-1.8.6.tar.gz"
  sha256 "243dc5dd225acd13fb6bae680e2de1816d521203b98a9cff588b66f141fffd9a"
  license "GPL-2.0-or-later"
  head "https://github.com/Cimbali/pympress.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a9ef0a8dddce6dc59d94b8306551292a7d729bac7cd65ee155525c1172f4522"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d45f3cf0538dbea0b86d894b29cad51a898474aa279aab3fbf5fd56a19951cf5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "502282c5a2e40f39bd9b13325cc4b51b7650416985ada770d3fe05fdc756f06b"
    sha256 cellar: :any_skip_relocation, sonoma:        "91a85242406ec115336bf6968550b383d7ccc175ce040690b90f1502b55a34d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2688fa0cd6b49f869cc7d6eab21815441c7d1c44e55e20fbef26f22fb75dd19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2688fa0cd6b49f869cc7d6eab21815441c7d1c44e55e20fbef26f22fb75dd19"
  end

  depends_on "gobject-introspection"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "libyaml"
  depends_on "poppler"
  depends_on "pygobject3"
  depends_on "python@3.14"

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

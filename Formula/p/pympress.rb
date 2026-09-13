class Pympress < Formula
  include Language::Python::Virtualenv

  desc "Simple and powerful dual-screen PDF reader designed for presentations"
  homepage "https://cimbali.github.io/pympress/"
  url "https://files.pythonhosted.org/packages/87/66/fb9f8f2975740ea8880de293eb16b543965387881c71ca323a00a5d77d8a/pympress-1.8.6.tar.gz"
  sha256 "243dc5dd225acd13fb6bae680e2de1816d521203b98a9cff588b66f141fffd9a"
  license "GPL-2.0-or-later"
  head "https://github.com/Cimbali/pympress.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "339feb3b225370afd424687da9db3203f4a305bea3cdaa0ab5ff90a7f0a84cfd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ed91496f2ac340987c1084be36b180a86533c6387bfc262214144805dd625107"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "88ed25f909c6c396a882e6c040c602f93201f6679c1d34ef3a87c1ee004bdf91"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f8ba43665083628ea2b064b4faf763d1f3e3c13081077f795aa3349ce909a40b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f8ba43665083628ea2b064b4faf763d1f3e3c13081077f795aa3349ce909a40b"
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
    # TODO: Babel 2.18 reworded the "no message catalogs found" error the sdist build relies on catching
    inreplace "setup.py", "if err.args == ('no message catalogs found',):",
                          "if str(err).startswith('no message catalogs found'):"

    virtualenv_install_with_resources
  end

  test do
    # Importing GTK aborts in the sandbox: GDK Quartz registers with LaunchServices, which mach-lookup denies
    if OS.mac?
      output = shell_output("#{libexec}/bin/python -c 'import pympress; print(pympress.__version__)'")
      assert_match(/^\d+(\.\d+)+$/, output.strip)
      return
    end

    # (pympress:48790): Gtk-WARNING **: 13:03:37.080: cannot open display
    ENV["PYMPRESS_HEADLESS_TEST"] = "1" if ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"pympress", "--quit"

    # Check everything ran fine at least until reporting the version string in the log file
    # which means all dependencies got loaded OK. Do not check actual version numbers as it breaks --HEAD tests.
    log = Pathname.new(ENV["XDG_CACHE_HOME"] || (testpath/".cache"))/"pympress.log"
    assert_path_exists log
    assert_match "INFO:pympress.app:Pympress:", log.read
  end
end

class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.211.0.tar.gz"
  sha256 "12409152bb95da59306a170eab2ff10323e585ac2da7c12f8bbd845189ebda96"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c1a2a2832ac93985632df21229d6224137617f81ac74d8c09b49e415491e5295"
    sha256 cellar: :any,                 arm64_monterey: "9c6ca46e2168d2284f0a4cb76086153ecd4fb17b08806edb7b81c703c08206ed"
    sha256 cellar: :any,                 arm64_big_sur:  "0b34f0a696b269786359d6b61994286285a0292fb4347e61cad7c969153e3b49"
    sha256 cellar: :any,                 ventura:        "4adf72dfa287a61e08baa2a4f3a8de4e774d63a349341abe6a69ac4cc28f579d"
    sha256 cellar: :any,                 monterey:       "937ff54990ff2c8d2edf3b4e884369314751cf668ef57715cb1b079d068ad297"
    sha256 cellar: :any,                 big_sur:        "2633437617fc67c2b1dc7b686e1abcd4bf6901b6be8541484bb25d8c9900ad13"
    sha256 cellar: :any,                 catalina:       "843f049a04f4630083ff770649b443e14789217a1c50cb26f67357dd1362be62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bb5fd9b1ab69f5373a68e570eb2dc4cc6dda8f0f316023f977918a9a2fa2476"
  end

  depends_on "ruby"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec

    system "gem", "build", "fastlane.gemspec"
    system "gem", "install", "fastlane-#{version}.gem", "--no-document"

    (bin/"fastlane").write_env_script libexec/"bin/fastlane",
      PATH:                            "#{Formula["ruby"].opt_bin}:#{libexec}/bin:$PATH",
      FASTLANE_INSTALLED_VIA_HOMEBREW: "true",
      GEM_HOME:                        libexec.to_s,
      GEM_PATH:                        libexec.to_s

    # Remove vendored pre-built binary
    terminal_notifier_dir = libexec.glob("gems/terminal-notifier-*/vendor/terminal-notifier").first
    (terminal_notifier_dir/"terminal-notifier.app").rmtree

    if OS.mac?
      ln_sf(
        (Formula["terminal-notifier"].opt_prefix/"terminal-notifier.app").relative_path_from(terminal_notifier_dir),
        terminal_notifier_dir,
      )
    end
  end

  test do
    assert_match "fastlane #{version}", shell_output("#{bin}/fastlane --version")

    actions_output = shell_output("#{bin}/fastlane actions")
    assert_match "gym", actions_output
    assert_match "pilot", actions_output
    assert_match "screengrab", actions_output
    assert_match "supply", actions_output
  end
end

class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.205.0.tar.gz"
  sha256 "c5a02755fa1309c88966b228e6d4be4c0360013920003e3fb8f6375b580aa783"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9003accf253f79084722a415499feef1415e904988e673b71e6f6c97d1d68923"
    sha256 cellar: :any,                 arm64_big_sur:  "897e68beadf9ffe90a8de1d7571cae3fe57fa4b723f94717ccb57eebd2550c04"
    sha256 cellar: :any,                 monterey:       "c169bf845ea2c83796141a85f8625c8f40e04eed73cb992021a5a4733d5fa811"
    sha256 cellar: :any,                 big_sur:        "b53748abe126e05099eea8fbb81f0e2cc77d093c6db4b2129ade6a7d07e8e420"
    sha256 cellar: :any,                 catalina:       "952110ff65b34242746fc6905b6364a5456ec74de944902888c5d7ce4da89771"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4f707f0cbeb099d32ff91425ff921e10a24134f3071dd0d1ab4017888713eac"
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

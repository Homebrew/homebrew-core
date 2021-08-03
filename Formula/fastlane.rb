class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.190.0.tar.gz"
  sha256 "b8b3a28331c6953208c59a563f5c32558b943136f73eebfe93f69d84a6f031ef"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "42891bbea638fc8a9be37c55393791571901de4061c7ebb32c32bb71f2ae16d1"
    sha256 cellar: :any,                 big_sur:       "7c5cd9de17f7c678163a856d69c8343a4e302a8cd06570396dae9d55788f128f"
    sha256 cellar: :any,                 catalina:      "3ce827ce2108771651efab4557c9d7244039d1f50a97cfb6b9e4d6f7f8c0677f"
    sha256 cellar: :any,                 mojave:        "ec3e730ed4e28fd1610d0b6f93cd9c18d57a2d8c24fbf1ee823f6216c9d8b416"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbd72050ded562f00a86d556265213ba3266ebd802f93a4807a99e7d5f891f74"
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

    on_macos do
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

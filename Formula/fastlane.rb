class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.197.0.tar.gz"
  sha256 "49fa64c1c5b2f16c4fa3cc8efcd31dc19f776164535b00f327d4133a790d837a"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "34c06d493a3b12e8871c03391edd3a0430f41292bbf0a1f49554fe44b7940361"
    sha256 cellar: :any,                 arm64_big_sur:  "8a509814804d47abdad480f57bcc0ecce8b0d9f533b2378c1b592f997d704c06"
    sha256 cellar: :any,                 monterey:       "a0aaa511e304402e69bdadba371a1b4a46906d9a0efc1dc62f3f3fe42db40845"
    sha256 cellar: :any,                 big_sur:        "ff0607ca55aebbc5830f9e9b76bb2d35584541ee7e4332d7692fee6d1b4bab83"
    sha256 cellar: :any,                 catalina:       "76d23e003e77dbca22885555ee6e8aa6a3b5b4c7095eaa6580513a5f2ae54c07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cea0f608e9addb74762b32e6549dd6744e071701e73715debf1cb8720bd0cff"
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

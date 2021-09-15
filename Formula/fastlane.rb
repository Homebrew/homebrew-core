class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.194.0.tar.gz"
  sha256 "2f9f6b7be0b50a1bfacf4b7a4540d8dc71f197d4071c87a08f5b3fce26d838a7"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "2f77b667be079557d0afb4bcfc3d36016ee80789c4887dadcc18023549a32d13"
    sha256 cellar: :any,                 big_sur:       "07a0f3fd1d0ece37e7a57742e2d8e08f2e46d81ad1abbdf89dba316bfbef1172"
    sha256 cellar: :any,                 catalina:      "6600aebbc15b7ebfcabc7bc982846b8f228d7ff1f61703dd6b89e3a3f577f993"
    sha256 cellar: :any,                 mojave:        "b5c4c1ea990f0ecc0e979c9efa9a1556f27c89beae3fe0f54e745a0e9fd44a2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04a16bcd79f84370fb42b5206020887f273ce556d4d3c13efa5e324b7ad9bebc"
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

class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.192.0.tar.gz"
  sha256 "e9f193075065c8617f4e52b3dbb0b671aedf76505d639887e961de3483c78a0e"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "5c53b9140b9639c42b519cca2602dd2db2fccfc28cba339eebcd7896f7dd1a60"
    sha256 cellar: :any,                 big_sur:       "291bd0b27949b22744f0352126fd86e2629850bd34c46f460830effa300c3e84"
    sha256 cellar: :any,                 catalina:      "18bf560d6c3e2ede31bd55a1d28c44f537fa3f0face2bed581bcd5cfc4172f0d"
    sha256 cellar: :any,                 mojave:        "9cb75404df58c541a89d0ceb2a25c6f85d20285d9cac1466162344957c6e533e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5694aaf31e5e466760cec992eb4f803c2eeeead8ff939778d0af9344105ff501"
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

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
    sha256 cellar: :any,                 arm64_big_sur: "29e7c2e27c35da05ef86a419fa90fb74cba18856348a9b2b219ca8a9a625fdc5"
    sha256 cellar: :any,                 big_sur:       "b52934868dd605546f78d71cc24ffe4f659d3c9e925042b82e3b62e490819c94"
    sha256 cellar: :any,                 catalina:      "80a1995c53a3ba7ef33684cf0e7fce61c1525ed64e8a4fad57708161491800d4"
    sha256 cellar: :any,                 mojave:        "a9216f81d213cb1e78e828f799ec0cc04c7ff4d47e45b7769d59ad1452cfaf16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8176a37c27e34431bc95db7cf5496fb8ac82f57294996b9e940dcac6966d340"
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

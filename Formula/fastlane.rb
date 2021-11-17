class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.198.1.tar.gz"
  sha256 "e6fd9f208619560e172f37bebbb5e44fabde2a741a8e4f3c692c2b6ccb996b07"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "458b44395e3ace2c5a3688b18ae4e50f1b20b41b42c87d477165d825bbc3336e"
    sha256 cellar: :any,                 arm64_big_sur:  "a8463c6550fd65e0194bdd2b954c4995b2490978c1057d0846f8b6aa242f2b76"
    sha256 cellar: :any,                 monterey:       "08fc1a77954a1b5eed27b9ef0fa1072cbe615daa186ad881e0a7036bb6d50b48"
    sha256 cellar: :any,                 big_sur:        "21cb413f97dbb5f6cc8dd8ca832c864362c7592cd325d3eed368ee019f63cfd8"
    sha256 cellar: :any,                 catalina:       "d2a87a1708af22c73c2f8de4602430137e7a295008674a21d41872930316aeba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "299301d827bec36affa20d6eff799b40f0d3f75b333f2071aba5fb9867ad6d02"
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

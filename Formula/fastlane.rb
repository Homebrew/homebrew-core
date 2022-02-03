class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.204.1.tar.gz"
  sha256 "551dd3f312cc997b980e734876d2bfb9d404e41118887bf89bed35ffc9e699b8"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c0275cb8f7415d611122629cdea2fc2c395d658c60234195611f0ffffdf3cbaf"
    sha256 cellar: :any,                 arm64_big_sur:  "c94346171fdf998beac0184f11f4784b5b307183c52ff55294c3370d51381a7e"
    sha256 cellar: :any,                 monterey:       "920ccfae6bc6abd083960b5a9373413dad484d32fc2f92a51f70c200b3e35d02"
    sha256 cellar: :any,                 big_sur:        "909454c567a93eb2fe2f6f4e303d5448a58dcc236f78ec1b1255cdc705cec90f"
    sha256 cellar: :any,                 catalina:       "6e0369fb9a806fa88fce244bd6bfc79c3dbce6db2a2100dd6a05acf7bdcb3515"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61cc68265ff06acc4f534c743e951ec0a45f8b42076ba455281bfd32616ad0bd"
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

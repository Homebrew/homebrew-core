class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.193.1.tar.gz"
  sha256 "1ab41c539202b63fc812881ac72eb18c55579055c174e565e1ddc90916e8c2c0"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "2e7f38eb0e5c0803f288f1aab424b7bff275267162eeea2e96689c2e6f67b549"
    sha256 cellar: :any,                 big_sur:       "fcf8d6a2fb3dc71597507649711593ea3c3c3c805019f85263d8ec021193b301"
    sha256 cellar: :any,                 catalina:      "2b9e85af926787182248177705f8f83f653a9bcd42c9e9f0b58325c73970b5e2"
    sha256 cellar: :any,                 mojave:        "0a4cd9d177ff64e3a0c0a54e75fbbd03d14f2181d353a63359f525fd086f4881"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50e6277ce388a0887e6a8972964cc8f82643498f4ad4a6d1ffe4dadb814d9c71"
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

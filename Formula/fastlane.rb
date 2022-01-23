class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.201.1.tar.gz"
  sha256 "03c505775a5f8adef45e6e2a9005174cf66f2359a35042a438ca90e294172b31"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a6239840a76221bf7b34252230a99aaa6680cb465fd54cb8078f333dc1ad0428"
    sha256 cellar: :any,                 arm64_big_sur:  "72cf67213e83f6f521d657240f8a8d229639a35b312e82da2d8a862d28ff122b"
    sha256 cellar: :any,                 monterey:       "cd2618de214a7952423acf0e772f0ccc36a75e1d43201d033ce093951c613d6d"
    sha256 cellar: :any,                 big_sur:        "b0414412ac47a4f1f3a398dbccddaa805e3e96d20631f53bfc6cdfac85f27b17"
    sha256 cellar: :any,                 catalina:       "2e60a940df5bd603e08c4b96b2169b77bab0eb2559efcfb0faafe9931dcfa5fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96e8e0d2ce9822a8905343128f6620da6818349308ac3a57a9c470d4cc75eb6e"
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

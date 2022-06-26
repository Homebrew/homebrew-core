class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.206.2.tar.gz"
  sha256 "bd973fe0d1e0d505aa320469efb5289f655aefffd2f27051d943d81bf41bbf59"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "614b8e883695ffd17287779a9f064f73b71c3dccf93c6405e262205e9ef1e1c5"
    sha256 cellar: :any,                 arm64_big_sur:  "50e7bacd9202c75647d26f96e9c8affa07ab3e5a26d770b2d9af80199122fc56"
    sha256 cellar: :any,                 monterey:       "43893bb31b8c03b003a03590347570267536e796d7ec812fcb25a5df3b5a3a3b"
    sha256 cellar: :any,                 big_sur:        "e8fd791eed001272711b58c66e5e43a8bf0cbc86374564bbd0c280231fb1d830"
    sha256 cellar: :any,                 catalina:       "80f6df14da7964fe33450e6ef5bbe75bbc810a335c982539108cdde2cba4f29e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "354b59c35e1ddd565a333bc900f6eb3d16bebf5bbc09044f8c33d4462f02d691"
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

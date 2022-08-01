class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.208.0.tar.gz"
  sha256 "21b6f35a58cbf0c3428ed43196d136d1c45a717ffd29703760c8f3faf57f0aec"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8f09b8643258e5d8f1390c89297b1d666a5cf64b175f2f53e66d72dd10c57592"
    sha256 cellar: :any,                 arm64_big_sur:  "2e6446698a9d0389a3dd0d0cf3ab1713efa3b6c4102db72d4d8f1738354f07f2"
    sha256 cellar: :any,                 monterey:       "6aec1fb66c39a2772d260bc519ef9f8226e3caad041a03ae344c075a26c068d0"
    sha256 cellar: :any,                 big_sur:        "af16bfd7d7fb23a3f4f7b602d0777a5173b953740a7fb6a0d13bebaad94f45f6"
    sha256 cellar: :any,                 catalina:       "aa5ed9b1eb8245331da361bcf848907759f0d9da02f7a344ba0cce58f51a5a4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e93117ebd9a8c6674da602ee7248e5d35023f13fdf8aa39ba14a2bc288aeeabe"
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

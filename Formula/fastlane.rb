class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.209.0.tar.gz"
  sha256 "2eb61aee26707cf1d1ffee6b25787beac6f3cf8d998c7bf3f545cc8b06dd4c58"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "304fd5c08c982b8d915c11c009b1b856ca0543dd8774586ae667bc9c5505472b"
    sha256 cellar: :any,                 arm64_big_sur:  "9b24232888f06d9089be9b0795e522b239741050379ade5bb2f1c1847d31cd83"
    sha256 cellar: :any,                 monterey:       "fd0f7883b21d6686cd4cb0a2c3ff36ee6917a42638413035499d27f639bc3d92"
    sha256 cellar: :any,                 big_sur:        "ac9638d1e654e346f688d220afc1e123809e411ba6e7d80a7e63e9a07b0d941b"
    sha256 cellar: :any,                 catalina:       "016c34cb71e1fcc7fca115c561ea34dac8737ffad08be5fed0d4209aed9c046a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d0cb7e5c1be8490799ed8f9e280d7b075c5710446b9f4d1ad99e7ca06614271"
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

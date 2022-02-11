class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.204.3.tar.gz"
  sha256 "588a1b4627d61a4cc5a518fbaeb73a8d750480011e237694a4051b112bddc520"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "eecfa69295885f2f909afce3d779bc8b746cbea7821f11145ded3c518f5cdf69"
    sha256 cellar: :any,                 arm64_big_sur:  "8fde89cdefca4e2492808f563b8820d8aad7b87a94907970ef284ba1b0e38927"
    sha256 cellar: :any,                 monterey:       "502d4b10b6ef13190ec01d53d14709b0137cc930884fa033c84a5e42e600c207"
    sha256 cellar: :any,                 big_sur:        "50399a990428997d329c6b28b3f2335116a1c59db0372615f2f63ef59e04e29b"
    sha256 cellar: :any,                 catalina:       "6a96668c390ae7e2e72c6d1a9cb23a8601ec3ad558fac807449081a0c4086c0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2d7112160271a10e7b7f5fb777d496e39e7e10c9e81b17fbd4858abe1b9c2ca"
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

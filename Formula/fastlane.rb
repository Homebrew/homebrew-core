class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.211.0.tar.gz"
  sha256 "12409152bb95da59306a170eab2ff10323e585ac2da7c12f8bbd845189ebda96"
  license "MIT"
  revision 2
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "57969622e71eddc2435663e1e3e3c1fc642c42ca509ffabab86725ac74cf40d6"
    sha256 cellar: :any,                 arm64_monterey: "b798f0960c985f347ef01cef85c28b2d29c09ef44a7275db9f89ff87c278bd00"
    sha256 cellar: :any,                 arm64_big_sur:  "3a1ffe846ffae8ef862c189eeabfdbfd1c5baef1d959b7f56a444e2d980dbbea"
    sha256 cellar: :any,                 ventura:        "07f2445e2645ef16d5bc0fddf7ad41422d3b7363057962ee1d8f7ce2c399d199"
    sha256 cellar: :any,                 monterey:       "ee3db840560f1367b7a774d2275d94d355b9ed0559e8ef93239101b6a8561731"
    sha256 cellar: :any,                 big_sur:        "498425f0162b3dc1ae1bedc119734d23dd7de5a6918cad0c949bec90c42c7ea9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7acc727ed018c608b3b0bd0faca04bbe11791ec73eaea6ba259d6860f8d3bc15"
  end

  depends_on "ruby@3.1"

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

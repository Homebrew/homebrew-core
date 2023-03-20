class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.212.1.tar.gz"
  sha256 "ea1a726fca8f7b98f0c6703b474e98f5ff40123f23d15740a4ffe783817ed15b"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2921963cac8ca922e893a9f7bf0526522fa06c22dcb495f788dd2856beb3ef28"
    sha256 cellar: :any,                 arm64_monterey: "8121ca97b89a7fa774bece457979427e093006dfdd8235b2d8557a98d523fd85"
    sha256 cellar: :any,                 arm64_big_sur:  "7497d172f96fba61d5c395d5ca66c9f0489dacf727761ad87976282b70f37d05"
    sha256 cellar: :any,                 ventura:        "fc78dca37c9bda5977d4c9315c845e465962f97fabae67e4e68270eab8757e27"
    sha256 cellar: :any,                 monterey:       "edf4d1a0fdd8103d79bfb2aa6ca5248e0bd3b9cbca4edeaf57e3f6b1e16278fc"
    sha256 cellar: :any,                 big_sur:        "1be49f78ee1047b8256b3e3e272086297568120a1b238da7e3b80e3b5d9221f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d767cb027354f049d07829f86249ade8a7d268eb0a85f369bd3b7a8713f13aab"
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

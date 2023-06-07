class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.213.0.tar.gz"
  sha256 "e3ad5e1d9a72286acd6ece3a785384ce58cb00a02f1e7841e288a09e0191bcc2"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "56bd2a89f06c2805ce3c95db4a2ec40e2b60187fa6de44b96b46ae095f5d9989"
    sha256 cellar: :any,                 arm64_monterey: "f5d73a73a7e38a7c02d192f4c4f502729cee8bea6848cf4aa88016a33ff9542f"
    sha256 cellar: :any,                 arm64_big_sur:  "2ed81c91f15cf8a4a0dae51940cbee6218ffbc2fa7ffc7301e512178826d49a8"
    sha256 cellar: :any,                 ventura:        "883ddb7c5c57c6c472deb169ecbede4f87a632ef7c0b31712e4da96498a48a26"
    sha256 cellar: :any,                 monterey:       "54264006a38d7d79e2ed0aed8e5a232c8cce7dc6bdb8102ccf2d4c769f7e54c0"
    sha256 cellar: :any,                 big_sur:        "88e28333815d396d9794b2b77b764749c443b22eeb156970e1194a63e4ef4809"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "784d93a68f7bef36a99d7304ff0e55168ca81abca301db9678b82d2ab61b47a6"
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
      PATH:                            "#{Formula["ruby@3.1"].opt_bin}:#{libexec}/bin:$PATH",
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

class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.210.1.tar.gz"
  sha256 "656427946ae7e1f817fa4866ce3e83455aa3c1896a9490764142d874a680c404"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4b5f4064301830e5561bf95a17dd2f916227f0a3dd60da079faaa0996a2ffd85"
    sha256 cellar: :any,                 arm64_big_sur:  "26d0a87c7d13074fd3aa6e2d5a64a9891e50d9b66bfaa5889e2e4cdae11eba4d"
    sha256 cellar: :any,                 monterey:       "ab2a354c1204215de5cfd0d1d4bb30daac6d5701e5d6314b4e30c995bd372b57"
    sha256 cellar: :any,                 big_sur:        "13c028cd099d44132623271808e11d5d73808096338a1d80c574b5c8d1b751fb"
    sha256 cellar: :any,                 catalina:       "2221bf9cae4935875591caaf2795a0fd69525a06fd7ce16091740b8d7785b0ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87e85833439c10044da6e85cb311451b193ab7927545b1b3e96790987f1f3f18"
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

class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.196.0.tar.gz"
  sha256 "4999d6189de4ef093926e4f7d8e524e1046528c94cb0a20ca3167fc959f475eb"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "a63ae5a7f3d3166335c47d95166b12a9367e639d1029f0d2607aa45d9568e273"
    sha256 cellar: :any,                 big_sur:       "3ae550b124df3aa24dfbbc1f8d8764e5cf4eecc83129c57e77fe92123b6d300a"
    sha256 cellar: :any,                 catalina:      "1a9b729245007a58007ec74c3850dbedd0bd084de074bcea8879216630eef8fe"
    sha256 cellar: :any,                 mojave:        "083665b9ea18c979d909a548fc2a1a27b36dccad2ddbc3b0431def28dff49e03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d6a32ec50d8ef08dc5a2ca4fdc68d899e052e061de8a9d546a8410f7dffafca"
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

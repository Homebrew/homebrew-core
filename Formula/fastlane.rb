class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.205.1.tar.gz"
  sha256 "80377c12c561362311abfe3e9f2fb43a03c12b0349e7d1b91432d1d5e85a97e2"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ff4a3e973af57cc58b45c2dc21b93dc917209465d08e643fb760496c9de970db"
    sha256 cellar: :any,                 arm64_big_sur:  "088b9f402ba88e2e49a27680d1b586b287fd45f2e944da8dde4f467daf07d97f"
    sha256 cellar: :any,                 monterey:       "8871d065b2a654e48f7733b3cfcb74da6027e9961478ae6b2f5fa71535255b6f"
    sha256 cellar: :any,                 big_sur:        "a8bd4ef076a84ce98f8e6f8fb348a00baffe0afaae19bded439cd2587f87b53b"
    sha256 cellar: :any,                 catalina:       "94da2bde0f33869d175cdfdb58963de80c44de24666b32e9cc94a939666d1c33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68476a3affe93ef00b78ca9bd8d1302e7fc667ff61e71b1925fb60bec640ca81"
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

class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.214.0.tar.gz"
  sha256 "b391fbe3684d8af0c96f39cb1739150b619f4e8e9338d00954a027a149e62196"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f69ed0248f62dec49d4bc6dff399e210b6428c17e741c6bd58e85b13ceefcd47"
    sha256 cellar: :any,                 arm64_monterey: "2a1ccefd1681e7434a81b266b8361c75f75e1106bee260e7e68e3eb403c0e9cf"
    sha256 cellar: :any,                 arm64_big_sur:  "cac17c91ab8686ed0047fedca2d92db382a62120a4227d8ce820ddad350e973e"
    sha256 cellar: :any,                 ventura:        "027f4861e0df6f21789e29f7fc7e5e67c45006c5c6f2d6c8c13cf5e7719a20c9"
    sha256 cellar: :any,                 monterey:       "31e5f23d8c78f2596d6c2f78e8701a8250dbdefbec8fa8881df6200b773e614b"
    sha256 cellar: :any,                 big_sur:        "2bd26f501ed100867736770042b0d1be1a0563dc0c8d84e13eefa964e0d35e70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2194209c115ecebd5cda4d3b8aa9d258a2f83cae35ed8387987eb8c2a7e31858"
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

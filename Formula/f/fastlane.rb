class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/refs/tags/2.224.0.tar.gz"
  sha256 "148b0327bdedd4e48c492224fd58182abcb904b690607420b70d4747d2979186"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c9236475a08366f0e20ae97f6fdf41c29c39900c80f23bd0f59fe40327e5d366"
    sha256 cellar: :any,                 arm64_sonoma:  "c66acf552133be876be8803043761659ad584705a908895deddffa20f0c75b85"
    sha256 cellar: :any,                 arm64_ventura: "4da2bb10b8b82b531e831e7bfb74d2334564e1d167822e8a61ddb7ffa692d4de"
    sha256 cellar: :any,                 sonoma:        "c2112d276dc8944fefa9dba94bcadabcb2d86490feb6cb3708bc466295fd83d3"
    sha256 cellar: :any,                 ventura:       "3bd574ef303421acf9c9315ffeec107e21623fa4f67d703911df11b8e56ddb83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da8f5ad6da01f2fe575de1f649cd93301ae1c09be862c4943221d7598fa6ee09"
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
    rm_r(terminal_notifier_dir/"terminal-notifier.app")

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

class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/refs/tags/2.228.0.tar.gz"
  sha256 "c481eb8fda99ec15fdae7c1092b9bfb0ab974fcc48fe814b790704cd2d890e45"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "52297aa4e3ad9f231165f69a99210782d30f3c3c9ae58a3d404c65f9703d5381"
    sha256 cellar: :any,                 arm64_sonoma:  "5da07d96754cd4b699dd747609d1762c4fc17b15458694d8a60d4d75b45f12e5"
    sha256 cellar: :any,                 arm64_ventura: "1a60996999192890ccc9071de1da15bc41c7b7d13996a50b8c2a89fc29333997"
    sha256 cellar: :any,                 sonoma:        "07a2082ab70092f81867a3c083f6be42f8b995dd5f10bde6b5ad672cae0e12f8"
    sha256 cellar: :any,                 ventura:       "248e1a5547abc5875ee1ebb8b03cd6642d6d7a54a16cf0737b8e717be0616e02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ea3f81ad8cc176ad6eb76a0414f94cd3a6eb2dd1fe419065200e5ca3057eff5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3179f95a053c9e8db0fb101a709129abfa474e4564da89d85c66328877a8559"
  end

  depends_on "ruby"

  on_macos do
    depends_on "terminal-notifier"
  end

  def fastlane_gem_home
    "${HOME}/.local/share/fastlane/#{Formula["ruby"].version.major_minor}.0"
  end

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec
    ENV["LANG"] = "en_US.UTF-8"
    ENV["LC_ALL"] = "en_US.UTF-8"

    # `abbrev`, `mutex_m` gem no longer with ruby 3.4+, upstream patch pr, https://github.com/fastlane/fastlane/pull/29182
    system "gem", "install", "abbrev", "--no-document"
    system "gem", "install", "mutex_m", "--no-document"

    system "gem", "build", "fastlane.gemspec"
    system "gem", "install", "fastlane-#{version}.gem", "--no-document"

    (bin/"fastlane").write_env_script libexec/"bin/fastlane",
      PATH:                            "#{Formula["ruby"].opt_bin}:#{libexec}/bin:#{fastlane_gem_home}/bin:$PATH",
      FASTLANE_INSTALLED_VIA_HOMEBREW: "true",
      GEM_HOME:                        "${FASTLANE_GEM_HOME:-#{fastlane_gem_home}}",
      GEM_PATH:                        "${FASTLANE_GEM_HOME:-#{fastlane_gem_home}}:#{libexec}"

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

  def caveats
    <<~EOS
      Fastlane will install additional gems to FASTLANE_GEM_HOME, which defaults to
        #{fastlane_gem_home}
    EOS
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

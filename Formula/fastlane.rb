class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.201.2.tar.gz"
  sha256 "f72b3befa46095c9118055b24e4ee2b45ff99304063f4c914b0a9deaf92bbcdb"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bb21c9fb1709b95b3b2ed13ddfb12d781547fefd6f15fda63f8e9a2104a7c343"
    sha256 cellar: :any,                 arm64_big_sur:  "ffac178cc4ecb5afc59272771af65da389f0c65c457bc5b8ff59456a4932359c"
    sha256 cellar: :any,                 monterey:       "d93a8b0237d53c2ee35826a39eb53ec3cd2ac1a6acbdaec1d2ad85b4942a2cc4"
    sha256 cellar: :any,                 big_sur:        "65c837c79543ea409c2a0c12425bc0e29342030a15bf3e5875794020cd1de40a"
    sha256 cellar: :any,                 catalina:       "69b61733d53ae2c6548d9d947ae1267937206e8e0458fa5e87f3b36cbc1e7a8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "456a9d932be6bd21be230572838f3f4e15ee4017a4a2e09d5589f3886cd1e010"
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

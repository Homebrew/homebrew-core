class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.202.0.tar.gz"
  sha256 "37167471084010ae99393bf67a0b6cf5a2e118489b2b18a901cf6b18b0caec62"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "aaac1b9f1cd6d3214a74f3b1c6403daccc37b973910c2cbbbdbaca608a11bd2b"
    sha256 cellar: :any,                 arm64_big_sur:  "add7f139c881cbed0dbb15f86065a4a7bd924eaf89aa0d85f1904df70851d767"
    sha256 cellar: :any,                 monterey:       "53d554165124388817d147af6c0a2ba3edda49a2dfca255d5e6339560ccb347b"
    sha256 cellar: :any,                 big_sur:        "ea75e1beb4c63904b3308c865eac16cb98c4d135464f9c42dbd097f17e935500"
    sha256 cellar: :any,                 catalina:       "3528434a5ac07a0ff49e64e983cd4706db2a73b42454058c4b42da6b0be2662e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efa4838cbcdf765ab8cc2baa1240a099d2c9cacf6105116db600a5394d95fd66"
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

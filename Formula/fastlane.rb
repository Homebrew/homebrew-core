class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.208.0.tar.gz"
  sha256 "21b6f35a58cbf0c3428ed43196d136d1c45a717ffd29703760c8f3faf57f0aec"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2e9bd096711d8d41c6e328de061f1ef278283c2b15fd9c5243d689dbe89eb0d3"
    sha256 cellar: :any,                 arm64_big_sur:  "913e0396440f486c054e849206a06afab2962200c12eeafac26df895a4660390"
    sha256 cellar: :any,                 monterey:       "0382fd5ebf6b31bcdf9fa598ffcb2518f998993e03520d6ae555d896f5cfffcd"
    sha256 cellar: :any,                 big_sur:        "0c92d4d2163352937ea441c63258e8b85ecb4af357a3b6ada36400c5e5979057"
    sha256 cellar: :any,                 catalina:       "46a6070e0b23a8b89840f07f9cc3ccf90d71e95a59b4f83b1e6871480ad2d3ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fef1c6f4a0c5f03e5509567365444eb2ed2f86ff3d3aa047e03f69baf51d1b2"
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

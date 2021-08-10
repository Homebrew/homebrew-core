class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.191.0.tar.gz"
  sha256 "ce69c4110805f0847d112e1214fad4739b2449d8b981bae64341e43667ac4efc"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "7420e0c87f24d728d151893c4934bb60012e60febaeefd3c2b69b151eaff8752"
    sha256 cellar: :any,                 big_sur:       "9aace3baa420e9c02297be7843fa2c8a08a4221fcd21a083fcbf4b6a71fd607c"
    sha256 cellar: :any,                 catalina:      "1b89f60e7ac60e302e4a733e1bc95c15f098efe5957dff01967d37859d6b9886"
    sha256 cellar: :any,                 mojave:        "ef9b142b3224cd7a08a62e56555c07f68dffeee4125a434be2d3c08662e96809"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6183f1def58023a80285c8bf0985514177a9b5d8d5b0082ed629fce6f4bd0f96"
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

    on_macos do
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

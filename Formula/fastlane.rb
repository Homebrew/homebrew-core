class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.194.0.tar.gz"
  sha256 "2f9f6b7be0b50a1bfacf4b7a4540d8dc71f197d4071c87a08f5b3fce26d838a7"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "41fc3113c5c50b981ae82890bad71c5ba2cfe3a2e54fb9c4f3d33408325f0bfb"
    sha256 cellar: :any,                 big_sur:       "618d9b6a706b807c2abb52ef64b92db798f0c368e1548b1744324ec5ed8b46f8"
    sha256 cellar: :any,                 catalina:      "1ad5c557597a2c2c222839aee41d8f95a37c6c91998336732b12fca6e6b7defa"
    sha256 cellar: :any,                 mojave:        "20cf78a32945b9dd9a539d85cf704b5673b4a6a1da60e3cc08a8e79f4a9e57a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c15642d5583383dad3753fc4d02db4f6e1c696d3b026c233593e95026f10bbe3"
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

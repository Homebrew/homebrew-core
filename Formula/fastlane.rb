class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.212.1.tar.gz"
  sha256 "ea1a726fca8f7b98f0c6703b474e98f5ff40123f23d15740a4ffe783817ed15b"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e36724aec66dbb971f5f68add9d8d28ccd7b6a359cab22c96085ddad32e4ab0b"
    sha256 cellar: :any,                 arm64_monterey: "72b94a1ce0d72bc373714656d35eeeb386cf48c50b5c722f9821ca84503ca8de"
    sha256 cellar: :any,                 arm64_big_sur:  "54f0dd2bdce91ac93647341c99d6a2e6beaf012afd1cec43e1188dc28c8032f5"
    sha256 cellar: :any,                 ventura:        "b0de6ec1dd236fcd9d3c2221d83a038abf7bc84cf099e259342990ebe7fe8e91"
    sha256 cellar: :any,                 monterey:       "1a20f8dd5ffdef339e2b596dbf939091473013dc269b22b26f038dcda1edfce9"
    sha256 cellar: :any,                 big_sur:        "7a63ad47060c2ee07b19d11259dea4e5386684697b5866abe36a04d9e0b776c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f560819913221cd90f974f17b7dd2e09bbd301624398a33b5ed1109ff17fa46"
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

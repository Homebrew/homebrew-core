class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/refs/tags/2.221.0.tar.gz"
  sha256 "fb3db5717d28ef04532899e73a1d747a6d3ac9330a47b3978b7201994ff526e1"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "82be89bedbe509a42478c78179910451da2d2fae1974af1df84983043102e3f1"
    sha256 cellar: :any,                 arm64_ventura:  "149b84a65383d6ee1a3fa647175d99b3264a983e42def263dd88b6529292b72c"
    sha256 cellar: :any,                 arm64_monterey: "45e2f79ed3fc69e38bce6ca7be1ac3c61513e3942acd872616062a225cb057fe"
    sha256 cellar: :any,                 sonoma:         "45f49301328d71d25755b3740b1612c8696d3df80bd217a657426cb0f94f8cb1"
    sha256 cellar: :any,                 ventura:        "12a81fcebdc2e669acc020ec361930cf2da1e67cf556d7e94f2d870d852a1635"
    sha256 cellar: :any,                 monterey:       "52baf56cf2dcefed4950d461d105e7339e344dd59e1407dd98341eb975de8017"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65e00be970f92313463a33e099b910a50fdeaa4d24e5f351dcd08902d9381a44"
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

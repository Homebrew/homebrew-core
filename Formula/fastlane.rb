class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.206.1.tar.gz"
  sha256 "31cb2423a60d4f5e0001a5914aef82dfdd40963092ca3b66626c1fb3d5e70eda"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e22992524090738446d9b722734cd5f277b7ac7cb1e3377a42d0e405b943475a"
    sha256 cellar: :any,                 arm64_big_sur:  "a447fd70a168249d19cd7536b6b30a7cfae1a96e8136c0a40b94ee62e493bd52"
    sha256 cellar: :any,                 monterey:       "200680d5f2f8a9ffda4296811f9839ba6b454fd548068a99ee9f336349525674"
    sha256 cellar: :any,                 big_sur:        "977ce0a04ec4565cad138d544f6eb8d7553dd4c05494d176a9a5fceab6144250"
    sha256 cellar: :any,                 catalina:       "35c4ff9f265884d556c38a33920afcdfbd960a104e1c9b31dcab10136c084ea1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cf80612418d89ed5df7e9e6ea7330dd5b8c93d2d7315d58bd01f73c96357cac"
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

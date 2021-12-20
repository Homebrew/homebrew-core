class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.199.0.tar.gz"
  sha256 "ba94f6de55121ea40ff06cd3355e891143395b4e47c2593f6e1868406b6e3698"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1e14775696bb04c7a39c82993957593208d2288dc969feb688f5a2204c48f49f"
    sha256 cellar: :any,                 arm64_big_sur:  "2f83661022e1a4ade114775a22a1235d5a5e744968151dabfe275d9f57d1e6f4"
    sha256 cellar: :any,                 monterey:       "9879096dd3b0695226c554c42ca63924cb6bf011f020d4dc9fe8a1b2f1b3f5aa"
    sha256 cellar: :any,                 big_sur:        "76adb63bc86e1a82317783e2f99be298bdb9b3961e24ac133f82abc400117c64"
    sha256 cellar: :any,                 catalina:       "775a482e0791041175ca1dff2dbd80eaf103cae17621392072c74074e3dd47e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0dc66caedaf9e0a327e4875ea93858b280f74f33d042a84a9b85c1152923f151"
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

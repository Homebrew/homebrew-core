class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.210.1.tar.gz"
  sha256 "656427946ae7e1f817fa4866ce3e83455aa3c1896a9490764142d874a680c404"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "aab7f8ad78a646f94073f2591825f564c0ce80ef17723947f15fc2a1cd1a9a4a"
    sha256 cellar: :any,                 arm64_big_sur:  "5fc91819ade06d96d7928d0353da355e0f9936514e9fe869c362f2698f878281"
    sha256 cellar: :any,                 monterey:       "76eb322a3c663cd8e93f985a736013e8821d77294246bcbf7a0cd59ab14d7930"
    sha256 cellar: :any,                 big_sur:        "d2a42f6fdffa22734c55f762daf9b4a4f5c61bcf6df1941070e3ff030c02604b"
    sha256 cellar: :any,                 catalina:       "8b17dca26fefcdef44127b5c629f63c2a47dd83f3714b4da48fe89959b5cf4c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43a02348a8614cf520a1fad8dfdf2c1d106b923b5b0c4b35de32971ba0235ccf"
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

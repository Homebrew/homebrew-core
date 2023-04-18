class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.212.2.tar.gz"
  sha256 "2163f42079b195ac7ace1a4a975c7f3a87ee67e3953d24077b304dc4f403363b"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "176795c639db7d7eaf6da641d7f8cb1249a9a9155ecbd776e35732f43127c85b"
    sha256 cellar: :any,                 arm64_monterey: "31550cf5a7c381798aa6a2f623e255acaa3a8855271f327b0f2108ffc6e58821"
    sha256 cellar: :any,                 arm64_big_sur:  "c195f9759703da2ab33fb98a7c5fa6900b741e129ce551a2332233e3e824a5e0"
    sha256 cellar: :any,                 ventura:        "ff118a5dc813cae5507ee23ddd89e14be4b280f53f55fc4fa94833af73f41e05"
    sha256 cellar: :any,                 monterey:       "a52ea0e9da63a1301a140bb20f9b6e834ca9bdb4eb513709eb392c0778920019"
    sha256 cellar: :any,                 big_sur:        "ae145baf3a4887aeae421ed709bf8330151608948b1d61803a62fdbd38a26e1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "245a00fb003d124890a743b0e606241f2b8d7b974fa95bca1dd285a25268d9e1"
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
      PATH:                            "#{Formula["ruby@3.1"].opt_bin}:#{libexec}/bin:$PATH",
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

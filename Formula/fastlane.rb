class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.206.0.tar.gz"
  sha256 "ac88a531d778901109936b797546dbeb120737e3102d6572c315ccbee09d0e41"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f4acc17c6df13e0e684359e1a8d289b1292b7ef783e46a04073f43a7584bc44f"
    sha256 cellar: :any,                 arm64_big_sur:  "e8e7c0a51fc5bedfb195471daaeba3af48ce5ce0e9bd3739eb9dd7e638e7edf4"
    sha256 cellar: :any,                 monterey:       "5a56962728d8ccd503efb36df6480b4c9f0b4f51559262a70d87ce9007c7d7c5"
    sha256 cellar: :any,                 big_sur:        "12ef4fddff602b87da3b1f76b57c8bfe5e05bee49ae4bc05cb70cb95ee7dc490"
    sha256 cellar: :any,                 catalina:       "54f827f9087d88a5c27e070c688d1fbdffb30d4018d6ecc493b84d9e327b1a66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40c79f277bef84ab23c835ef780b8516abb98fa750524c88b7981021e4dc99fb"
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

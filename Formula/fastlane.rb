class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.204.2.tar.gz"
  sha256 "2c48f006b69ebe7be8632f08562f6260b0d34735daeb45f93e3c1783ebd3debb"
  license "MIT"
  revision 1
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "dc350d54a9634c109916a11ef13458011184232c1218467158fd740806c7ac9a"
    sha256 cellar: :any,                 arm64_big_sur:  "408f427477657776cf8d9b29a3b4f2d06503156b005c3f86f34ddddbd52594ce"
    sha256 cellar: :any,                 monterey:       "e2d5d4ef15879c16df3fa6a793dc0648108057c52e4036184bebc359611b16cc"
    sha256 cellar: :any,                 big_sur:        "f897fa5d4c812ada98275963d9684c6bc84c5cae0cce517abaedfba6075b51f9"
    sha256 cellar: :any,                 catalina:       "69b8431a02db6042579d5eafea0b6a69f6fc1f05d72c598b6a1e1ecb2378c7ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cccae3720f21985a8c78a00f6d71119180676b5428a26ca7d993fb560f61bcfa"
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

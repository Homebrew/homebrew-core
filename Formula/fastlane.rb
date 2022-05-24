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
    sha256 cellar: :any,                 arm64_monterey: "5b54a28358d4f7ede81b1b83c9b34f42e898ffb348b9cb2f7ae9fd7e8f37b980"
    sha256 cellar: :any,                 arm64_big_sur:  "6ce12df6e3bfb1a1d9935a9be3c59ad7918a742312aafdf8ddb94d8fbb83d3c0"
    sha256 cellar: :any,                 monterey:       "426e58aa7efa7a008f58722bba49ab978b3d3ad79b31fb79f78ace76ef212207"
    sha256 cellar: :any,                 big_sur:        "aa066037746bede21719ded0334feb75d8feb8d392c5cc5495bba496089d1658"
    sha256 cellar: :any,                 catalina:       "3f931f98ec1ed8c82f85351efc3f6583153a1d604d5f66948abceb23e3225d1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ccaaccbeaa9eef762371f1d887eda3a0e15c06dfdc540c0f98aa8f1afc30248"
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

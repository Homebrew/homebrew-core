class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.205.1.tar.gz"
  sha256 "80377c12c561362311abfe3e9f2fb43a03c12b0349e7d1b91432d1d5e85a97e2"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "dbaab63e9aea499d68bfc99c225d7a6c875e30d86c1e17123c72e91ace6e4335"
    sha256 cellar: :any,                 arm64_big_sur:  "18ebe5a888ed502521b6645c7bed4d9a7e5688c3a38d2432e36663da8bba8f08"
    sha256 cellar: :any,                 monterey:       "7750f157215d2ab122ece496651b28bedf864ade0b78dbcf470c5f493a6acb22"
    sha256 cellar: :any,                 big_sur:        "9d8ce107a98746decd69d3c8fa280a132b718a4122bf36566908a7fab056b268"
    sha256 cellar: :any,                 catalina:       "1b0c7205263825fd654b29a9b74bd7754ea908098bb5652369165c5806310778"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48905c9a01e5dce2599cd3d069c16ce95669ce951307342c343ec5cac4630aba"
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

class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.210.0.tar.gz"
  sha256 "0f07de18f44c204640d028c3fbe210f738481dea62bee7e23ccd0bd4d7bf750f"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8d80dc6569f22110aa5167d3866f9668f6b7fe3aac17ad0d048140b3a72a6584"
    sha256 cellar: :any,                 arm64_big_sur:  "7d398cdda72d8dd4afe378c23e8f1dcbd4b4ef437e9129d5080749fcb005ec62"
    sha256 cellar: :any,                 monterey:       "7e9ffffb8e393802464feafe82abe77887227a567db8c807b74ef992e2530d96"
    sha256 cellar: :any,                 big_sur:        "84b79f8d0f61b1e58866c78fffff21a9c412da37fd8488dbac6420541ad394b6"
    sha256 cellar: :any,                 catalina:       "34afd00655477f396bd937ce36fac2cd808d5391584167fedb8550a7e3b503d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "421e538917afd0b997fe374f070876d2b2139a16ce3a40a5e353d00a1a3a5abe"
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

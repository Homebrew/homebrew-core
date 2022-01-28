class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.203.0.tar.gz"
  sha256 "1ae515378709c349f2a412411723434b43a95df2272a28806f0425dd6111604f"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c31769694eaec3ff236947fdda5c066af960e8cbee9fddd326075eb5820f4ac7"
    sha256 cellar: :any,                 arm64_big_sur:  "ad9e5faa8523a5eb10dd67ed9a4203b353825df7efd29d7d9da2529138682a9d"
    sha256 cellar: :any,                 monterey:       "6c91944c730e2d5bc74cd5f0a43c171bb6e8c9656b551a679147eccf77f6e84f"
    sha256 cellar: :any,                 big_sur:        "6c54ba43f249ff41932fa555fc4649a949b06dfe0a37eb2d5c48ac47f6a4fff5"
    sha256 cellar: :any,                 catalina:       "9c73ffcdccda417aeae76567941ea08935ecb351d0e59fa351ee524e8456e754"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "287c992427ddc486b961df8752c845a8719ef49b36d615163f18677aab5b2e13"
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

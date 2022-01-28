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
    sha256 cellar: :any,                 arm64_monterey: "134f881b59bd4d99ad4fe8468416a42e5bae1f1d21a5737d1e2db207405a7be5"
    sha256 cellar: :any,                 arm64_big_sur:  "97d92ce65f4875e57004f86cb77d5b0a3c261a8c4e153a2770de5af6d9c6fb16"
    sha256 cellar: :any,                 monterey:       "ee15c6c0af017f4f1f916404e55af2133587e29ef1e114f100efe0759dee22b9"
    sha256 cellar: :any,                 big_sur:        "aa912d22039f7df4401e132b1a00450f8dd04a5fd2d51aa725f24b1263035d52"
    sha256 cellar: :any,                 catalina:       "214bd069c2e851e988e56b2bc0f47c67a9ef4bd90418b338ba684ea2795d1def"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c9f7e0501ec7187a0258a9a79b29724a6b32ba4c733f3e2af372d87b85ba814"
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

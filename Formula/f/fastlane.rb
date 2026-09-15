class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/refs/tags/2.240.0.tar.gz"
  sha256 "461b91f14602b640a6d0b20d98de9ffcbbf7875c6371227e67cff4ed11e3d4ab"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ea3ea370bc1a867bacfc91c328fc80a5add76014feafbbd87d5dea0179ec9908"
    sha256 cellar: :any, arm64_tahoe:       "e1d6868772f6a214fd6487c4e4d3ca49c6f77a7830401987006af69ef39125b3"
    sha256 cellar: :any, arm64_sequoia:     "7c16a984734176676add3ec50d7890c0848ccb95851a87289d853266068b1a56"
    sha256 cellar: :any, arm64_linux:       "de1540ba8fbdb690871269bd25c1a7197f7a5269e0a65a6b9055d4a43ab4aeb7"
    sha256 cellar: :any, x86_64_linux:      "6d2872127b75a77aebff9e8fac5bee6b3ae8196058dd2cf0d89c2905477b30c9"
  end

  depends_on "ruby"

  on_macos do
    depends_on "terminal-notifier"
  end

  def fastlane_gem_home
    "${HOME}/.local/share/fastlane/#{Formula["ruby"].version.major_minor}.0"
  end

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec
    ENV["LANG"] = "en_US.UTF-8"
    ENV["LC_ALL"] = "en_US.UTF-8"

    system "gem", "build", "fastlane.gemspec"
    system "gem", "install", "fastlane-#{version}.gem", "--no-document"

    (bin/"fastlane").write_env_script libexec/"bin/fastlane",
      PATH:                            "#{formula_opt_bin("ruby")}:#{libexec}/bin:#{fastlane_gem_home}/bin:$PATH",
      FASTLANE_INSTALLED_VIA_HOMEBREW: "true",
      GEM_HOME:                        "${FASTLANE_GEM_HOME:-#{fastlane_gem_home}}",
      GEM_PATH:                        "${FASTLANE_GEM_HOME:-#{fastlane_gem_home}}:#{libexec}"

    # Remove vendored pre-built binary
    terminal_notifier_dir = libexec.glob("gems/terminal-notifier-*/vendor/terminal-notifier").first
    rm_r(terminal_notifier_dir/"terminal-notifier.app")

    if OS.mac?
      ln_sf(
        (formula_opt_prefix("terminal-notifier")/"terminal-notifier.app").relative_path_from(terminal_notifier_dir),
        terminal_notifier_dir,
      )
    end
  end

  def caveats
    <<~EOS
      Fastlane will install additional gems to FASTLANE_GEM_HOME, which defaults to
        #{fastlane_gem_home}
    EOS
  end

  test do
    ENV["LANG"] = "en_US.UTF-8"
    ENV["LC_ALL"] = "en_US.UTF-8"

    assert_match "fastlane #{version}", shell_output("#{bin}/fastlane --version")

    actions_output = shell_output("#{bin}/fastlane actions")
    assert_match "gym", actions_output
    assert_match "pilot", actions_output
    assert_match "screengrab", actions_output
    assert_match "supply", actions_output
  end
end

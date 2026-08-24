class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/refs/tags/2.238.0.tar.gz"
  sha256 "21feb7393bb4078b7e07cae82b7359d47a107b5195cd2a4be6df964d4646fba5"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "12530ba116861b25b9354abd8c37b3606c6282140a4b299d97c9be6958ba40c3"
    sha256 cellar: :any, arm64_sequoia: "a3a5a17849fe9e5c9da2d3082163c745492a9be4258681e4067f45bdd9b152cd"
    sha256 cellar: :any, arm64_sonoma:  "f19901e1320be728e45d7fe8c00c1b4822fa210e2c6c88812f4cbed34bd1d9b8"
    sha256 cellar: :any, sonoma:        "b7b2f435165199d59f2f0834cf47109c9d36b125121233f9e50f606a8472cbf7"
    sha256 cellar: :any, arm64_linux:   "0ac5c2d7fc81524fce9ac79d0ceac356b454275d686f04fd55e10a51006224c0"
    sha256 cellar: :any, x86_64_linux:  "453d8037b197ee24619aebb2c091d6662855cffb9bed51c7aa82da6b5e73b7a1"
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

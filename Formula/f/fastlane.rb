class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/refs/tags/2.227.2.tar.gz"
  sha256 "c85ca2e8bdd49e5f8c5c3e52ac76fae382dfa3a7ff61873b161841675d4fb2e8"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bae22812dd23eac97d59d28cdd7fc848566f9165a152f8d44149b840fc295b4f"
    sha256 cellar: :any,                 arm64_sonoma:  "e9ba1459dd4db8eff05f6cbc9dbcf6116049d39e022251e9383cdfbb623bb88b"
    sha256 cellar: :any,                 arm64_ventura: "45d03fbcfbd793e21dda4006406ca55e0510bd19e630e51fb2977e69451ee27a"
    sha256 cellar: :any,                 sonoma:        "1a264d5656f2c16b4dbcfbd142605a7ae84b31d5bd4e0878b1de3acbbc6e1fa5"
    sha256 cellar: :any,                 ventura:       "9a127e2e66860a671c09276d015495c212d138ab86fd01d59f12569f9051f741"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f4c84d128821cc1c03ab7d213a8991b6468edffb964401d8557641fe0718009"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbf87e1cb8b37fc22d2b6fe16a12f9c11ca4fa0fef799c549e7ce53765ac9d96"
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

    # `abbrev`, `mutex_m` gem no longer with ruby 3.4+, upstream patch pr, https://github.com/fastlane/fastlane/pull/29182
    system "gem", "install", "abbrev", "--no-document"
    system "gem", "install", "mutex_m", "--no-document"

    system "gem", "build", "fastlane.gemspec"
    system "gem", "install", "fastlane-#{version}.gem", "--no-document"

    (bin/"fastlane").write_env_script libexec/"bin/fastlane",
      PATH:                            "#{Formula["ruby"].opt_bin}:#{libexec}/bin:#{fastlane_gem_home}/bin:$PATH",
      FASTLANE_INSTALLED_VIA_HOMEBREW: "true",
      GEM_HOME:                        "${FASTLANE_GEM_HOME:-#{fastlane_gem_home}}",
      GEM_PATH:                        "${FASTLANE_GEM_HOME:-#{fastlane_gem_home}}:#{libexec}"

    # Remove vendored pre-built binary
    terminal_notifier_dir = libexec.glob("gems/terminal-notifier-*/vendor/terminal-notifier").first
    rm_r(terminal_notifier_dir/"terminal-notifier.app")

    if OS.mac?
      ln_sf(
        (Formula["terminal-notifier"].opt_prefix/"terminal-notifier.app").relative_path_from(terminal_notifier_dir),
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
    assert_match "fastlane #{version}", shell_output("#{bin}/fastlane --version")

    actions_output = shell_output("#{bin}/fastlane actions")
    assert_match "gym", actions_output
    assert_match "pilot", actions_output
    assert_match "screengrab", actions_output
    assert_match "supply", actions_output
  end
end

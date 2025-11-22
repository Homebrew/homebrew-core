class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/refs/tags/2.229.0.tar.gz"
  sha256 "8caedc04fbd775a35173a2fbc6668e813cd30469f5adb7f27efcaca68f2861df"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2c9d81476743c4febed15aad1f3ae6cc80d2c208ffbacd688700a2c9fe63020f"
    sha256 cellar: :any,                 arm64_sequoia: "f843463d9f5dc53742af1406e413b40e7ba431d3595e5b77afbecb6749769092"
    sha256 cellar: :any,                 arm64_sonoma:  "a1fd6fae37652bc639b695b334554dc83ed6fe990ab30674e5ffb92be5671143"
    sha256 cellar: :any,                 sonoma:        "2b4cc33271f0bdc41fd3ccec614d45f6213eacca01d1d6d9e90b1f5d4bec4626"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87bb120d25f95227f60f115d68b745613c702cc48bdde197104be7b2ed9dd848"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a68295c9a5c71d22ae2385883e95785b7116324fcbd57c2c3de9e9b4efd2619"
  end

  depends_on "ruby"

  on_macos do
    depends_on "terminal-notifier"
  end

  def fastlane_gem_home
    "${HOME}/.local/share/fastlane/#{Formula["ruby"].version.major_minor}.0"
  end

  # patch to add `base64`, `nkf` gems, upstream pr ref, https://github.com/fastlane/fastlane/pull/29767
  patch do
    url "https://github.com/fastlane/fastlane/commit/5a1264350c16c83f42937caee6071a5fb52892d6.patch?full_index=1"
    sha256 "00c2e201544ffe211ce2e1b0977bc269a6b89213e62e1e1b11b1b6eb7bed8960"
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

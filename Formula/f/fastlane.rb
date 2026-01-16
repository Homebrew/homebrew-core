class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/refs/tags/2.230.0.tar.gz"
  sha256 "e496600b49a3eda2463964eedcfdb4d0c25751cf2a1fa59de9f09719d249ed06"
  license "MIT"
  revision 1
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7b973a13df552756585875bf515b640f57d7ff70340bc5041942af85f7b8713b"
    sha256 cellar: :any,                 arm64_sequoia: "dbadf70b610dd92d5b41173f1472378c916389d722c6533fe2e0b2a6343bb42f"
    sha256 cellar: :any,                 arm64_sonoma:  "7dd6e7485371197435dd40619e916b45117e65a2a40afd38560f975cb4cae32f"
    sha256 cellar: :any,                 sonoma:        "d87c9a5cec845d8fb76f94aaa1eb2cb697f5e52dd369d90a48eef376f21f808e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc0f6d648c40c39fb4f70479b64aa75cb0470f5aba76fd47483ebbc8893b2dcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e393a4144f818dea97353b6b04d991f2c4f89bbd021399f7545bf81ff0d916b0"
  end

  depends_on "ruby"

  on_macos do
    depends_on "terminal-notifier"
  end

  def fastlane_gem_home
    "${HOME}/.local/share/fastlane/#{Formula["ruby"].version.major_minor}.0"
  end

  # Include gems that are no longer part of the standard library in Ruby 4.0+
  # Upstream PR ref: https://github.com/fastlane/fastlane/pull/29833
  patch do
    url "https://github.com/fastlane/fastlane/commit/104113ad1d16ad44cf4a74e60993ba44cef2d787.patch?full_index=1"
    sha256 "ccf3358fca5e43a20fe89f114a5234efe1e8c897c384d9db7a0d13d9c3c3edfb"
  end

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec
    ENV["LANG"] = "en_US.UTF-8"
    ENV["LC_ALL"] = "en_US.UTF-8"

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

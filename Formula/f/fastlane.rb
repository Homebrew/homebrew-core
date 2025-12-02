class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/refs/tags/2.229.1.tar.gz"
  sha256 "3e9c945e804cf99f20e0d29fa91c2fbd7cf303c171cf7b36c7b125b49a776e45"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0c70a893ee9bda5fe70704a86c83a3fe077fb15cf3d5d2e90288d55a3565d457"
    sha256 cellar: :any,                 arm64_sequoia: "dad9fd2c520ef5c6aef07d4cc72f6b7e96200b2d1399c1635f9064144ab270b5"
    sha256 cellar: :any,                 arm64_sonoma:  "6f43ca74792b08b7fdb5aaa38d47ee1638ecace8e2068c91e06cfc8df243113e"
    sha256 cellar: :any,                 sonoma:        "0505ac896e42a2b22c49c87ea7f9b41d78f3992c25db53abc72f5a911a31f458"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b8b7a3e5ce981682b4309b8a3d77a40ff7f2d1ed259bb1a817e59026d12359b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57e24bbe564f09cc51f39e43432601597685b442ff8f4dbc3c32bc0050d9d393"
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

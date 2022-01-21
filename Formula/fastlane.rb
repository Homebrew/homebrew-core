class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.201.0.tar.gz"
  sha256 "444a44e6bd159edfbdf5698a9d2a0e7696f6553742ff0be862b7835c5ec61d71"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b1345eb800405991ccb02122a37d60aed7b7350d1241baf4a0bba29e4dcd5199"
    sha256 cellar: :any,                 arm64_big_sur:  "7fdd91c6c31c0edf643cee73ec9a22d5a907c1277d89f863a4d5e6d3564faae8"
    sha256 cellar: :any,                 monterey:       "93d5fd89fbe69d3b002fca3b71a545349cb575c5a8e22e342b633002c889432c"
    sha256 cellar: :any,                 big_sur:        "86a3771cf13d644da9640a19db6f886a92a6d09f1344afbc94970541a99ae5ba"
    sha256 cellar: :any,                 catalina:       "3a58a107ccc4b2471a56f2f98c84c3002bdaf21ad461ab1992b3d3dd7a9516f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f345173277789bf8d902fd280d3a4ce36e0cae89261fb0727874c92148ffa2d8"
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

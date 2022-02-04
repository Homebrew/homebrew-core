class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.204.2.tar.gz"
  sha256 "2c48f006b69ebe7be8632f08562f6260b0d34735daeb45f93e3c1783ebd3debb"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e37757e080b9f574fa5c59072c968c8d23a818a8a5fad496bad6cc36f18e8959"
    sha256 cellar: :any,                 arm64_big_sur:  "f69a930b200a0b357925ccce290ac51871720723eb7fbdd88c6239ec5b369ecd"
    sha256 cellar: :any,                 monterey:       "d8fb2b6d9c06e8acb504e67da04fa533753bcccf693dd6e7304a12c3550058b8"
    sha256 cellar: :any,                 big_sur:        "4d7a9d9095f43eda0f741db04bc8b8eeffe29de877cb33ece11a5d974c24ba9f"
    sha256 cellar: :any,                 catalina:       "2a2fe9c73715e8fe7a054a2517a3dd6be5fb83dd543536c3a34daae4a5216ec6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa52ca66bd5ad0bc4027e1c76dac1fd04285111071a6e95d046176e93944cc19"
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

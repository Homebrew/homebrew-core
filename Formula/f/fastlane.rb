class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/refs/tags/2.220.0.tar.gz"
  sha256 "2d4b9b368ffae0543abfe7c166774980019d1ee9d6295fc1830657eda4ea4060"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e3be53e4fd58f2708b592714adcb0c984069f183dea610abe420cf1060ad49f7"
    sha256 cellar: :any,                 arm64_ventura:  "0c162caf307f541439ecac614cc70e09f9741c4ae8af3a70273b4634fa41ae19"
    sha256 cellar: :any,                 arm64_monterey: "7022c9f08c8bdf092098432afe2075c796a82e7a23183dd84215142d9e32e2b7"
    sha256 cellar: :any,                 sonoma:         "6a3ae8a29fde517c88eb20d56d386733c7bcd6ebb09e584b06403fd070e4c4e6"
    sha256 cellar: :any,                 ventura:        "fbafd5ec6f5bdfb082994af5b3725c57e39e6720312eaf5a042f0a80be1d6999"
    sha256 cellar: :any,                 monterey:       "9c64f195d2df3e31f66d6cd99e8b75e40679ec4a0ccbfc363ca6265b4be783b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "084260d00ab6786aff812a2833206e9ee20a55d2960a7a45c0f9fe3ff7a072af"
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

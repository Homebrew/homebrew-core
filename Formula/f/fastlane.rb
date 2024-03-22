class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/refs/tags/2.219.0.tar.gz"
  sha256 "100458a3bc60c23fbc374748b7eab3f4666aa50fb84ffe94daa9e074d5dbf059"
  license "MIT"
  revision 2
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8c5022a9976ba8df487627ad71a8b31f89cbb2e600e85596aa3f34cb2cfefb4e"
    sha256 cellar: :any,                 arm64_ventura:  "8f913dc152de63df86c8360b8ec9dfc940cbcd43c0b4c6c2acabae545a57f836"
    sha256 cellar: :any,                 arm64_monterey: "a4c708aff31dc26df462628e011fe56906f97ed018ecd98cdf5b112e7b0303b1"
    sha256 cellar: :any,                 sonoma:         "3039fc1313f1d5f6b4ee995db17e0c61bf2fee1a53bcb823a4898f0b60a5f9bc"
    sha256 cellar: :any,                 ventura:        "099e7108d21bc4f62ce25d4df3d5a115a4a6af0278a1127dd3f8cfa603a02fbb"
    sha256 cellar: :any,                 monterey:       "68c09c344ed1005c51d9234c2ce4833aae206daabc76fa3aa45b95bb9abecc2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c24e2cb0e786cdd719f364fb73d5e674829b402b6df272f3b0da2b54ef97741"
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

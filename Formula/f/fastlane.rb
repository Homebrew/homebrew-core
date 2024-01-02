class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/refs/tags/2.218.0.tar.gz"
  sha256 "aed7d5d81db45ec41ff5aad978f490c64747c18ce250259a0b1e8f4d984b86f1"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "91af5f1200f28c3373e0c42829179cefe1996f454c635f30ca2cbff451915f6a"
    sha256 cellar: :any,                 arm64_ventura:  "7fa76937d5e469bcbcdd938547a290523a442650453bc45d1c6e5d96ee5d2687"
    sha256 cellar: :any,                 arm64_monterey: "b4c88dd9c23442eb89f9e793fced96a0d7aa37fcfbea4165c5fcc216d310d875"
    sha256 cellar: :any,                 sonoma:         "b9546e49d29b7a5166e43dce8ed2b7b15308be396253de9d0dce27b01bc8caf2"
    sha256 cellar: :any,                 ventura:        "3c60d7d5471d5b4bc25aa940c62b5b8fa082556cf6faea3ff018e9771d1977f5"
    sha256 cellar: :any,                 monterey:       "7bd2b50d0320ae8c8ae226fc96803469411065629caa8e9aef99d14b4f01bfaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "669a63bf74a8000322f6191d49d6349a144d45122718ce0062dbcd7af58cb115"
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
      PATH:                            "#{Formula["ruby@3.1"].opt_bin}:#{libexec}/bin:$PATH",
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

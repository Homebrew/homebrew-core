class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.196.0.tar.gz"
  sha256 "4999d6189de4ef093926e4f7d8e524e1046528c94cb0a20ca3167fc959f475eb"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "7f9d07c9b87207f34bd750aba1386fa7dc1b591c5e7957945980584b27e33d77"
    sha256 cellar: :any,                 big_sur:       "ab0ad3d06df2bb6d5fe5548a90c7ed67341accd98cc07a7b6b49598255b02e89"
    sha256 cellar: :any,                 catalina:      "abb5065764419a15dc5f646c2822a730df8bceae91a60dd9a25e54797833becd"
    sha256 cellar: :any,                 mojave:        "fc852dc0baaccc5e414077a7f0aa09ea51e11bbfebe3aebb066e5a2c6cad6e12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e760119af848a30ac334b1cc41d7d94c3b85bb07f92d61ee6473339028e70138"
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

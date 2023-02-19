class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.212.0.tar.gz"
  sha256 "78f32731b4842a44d861684338ca75d253146fbe6248d0c89fad117d38b592c1"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1c2a65f5e77e18eebc68ea6f24abc81cbb8bdc4283b3d83b6a992ecc5def2273"
    sha256 cellar: :any,                 arm64_monterey: "3053cda51a643e8d75eb112ffa31d782e37f69990bf549b6c13b0a5cca63e732"
    sha256 cellar: :any,                 arm64_big_sur:  "fd196782bb47f7d70889e52d0918e27d9474cae74dd071423ee210dc9f022eb3"
    sha256 cellar: :any,                 ventura:        "9124f5e8ecff93c6d37891a79412dc0cf55e71135ab546bbedd0756196897569"
    sha256 cellar: :any,                 monterey:       "5bd7a4c6cc1b32e1e112a4a851db150499fe130530527484de33563880494b39"
    sha256 cellar: :any,                 big_sur:        "27b9c92f6e23e1b852620cdf315343dfd6bb7a2c9b0f616bd61ca13d2c93fd3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39feb282ba261c69a8cf97fd3414e536a7b434827e286d896d3870321ae879fb"
  end

  depends_on "ruby@3.1"

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

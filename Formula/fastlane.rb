class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.199.0.tar.gz"
  sha256 "ba94f6de55121ea40ff06cd3355e891143395b4e47c2593f6e1868406b6e3698"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "094419d72078f0891158a4dac91c39c417b925c2371bf7d80e53a0cb00a07e4d"
    sha256 cellar: :any,                 arm64_big_sur:  "2b97716fb27109198b33ec73ffb4567f79b6d4a4f3c417c327666c0e127054b1"
    sha256 cellar: :any,                 monterey:       "20e6e1c2e4f17bdabaac891b2fc2406e4757ab904d9802f6995f6f989895419d"
    sha256 cellar: :any,                 big_sur:        "8511a3330e353077224e954c192841ae1161aefee96de99edc54fd789a98e85b"
    sha256 cellar: :any,                 catalina:       "ca7c61d3c363cb1890a73d2a030dc4fa13b5c702d4ef0d073df8db7b2db5f0cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "365135bd725ea31e6e3666316f5d7d7c1de844ea2feafafe81a431a888a2ef73"
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

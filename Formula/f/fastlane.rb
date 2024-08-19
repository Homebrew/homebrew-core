class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/refs/tags/2.222.0.tar.gz"
  sha256 "2e4624170873a03f9d59b333dd3e2c0ad9905848bf496e3ac98766f7d068407b"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5759abba16aa2aba62600479800b8806bb630f045246fc9c390c837644938028"
    sha256 cellar: :any,                 arm64_ventura:  "cae603c32444e2a1163e24dbd9d0aebac6b9edfb0f06ba8afee21d664037c8f3"
    sha256 cellar: :any,                 arm64_monterey: "59ef9d10a908dd9468b3727ff8254911e3f5f8b375de0cc7f3c97b691c289922"
    sha256 cellar: :any,                 sonoma:         "f027aae7bf6d91e0c0c9e514c1e8ef62842692d40e163d77e5538c5c52bc12fa"
    sha256 cellar: :any,                 ventura:        "0a8a4f5b90c99582956e807d24ed58f67eafaaffb5c0c580b9579461fb269a7d"
    sha256 cellar: :any,                 monterey:       "f94ce123b22d3cf0f0870499f8a58f033cb55af7aabfeedf79e3d1d2ba14f0cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dd14a74db870dd3966eb32ec97558f0a1f5add17ca56f238088397026315b96"
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
    rm_r(terminal_notifier_dir/"terminal-notifier.app")

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

class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.216.0.tar.gz"
  sha256 "f525e6114eff667977bd3ceae1cb1342049f81654f7baba5c01771e315ef61f4"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f60ec0538c55869a0097200e23b3cfb8a38ffb42bbcb607cddb5e11f88566665"
    sha256 cellar: :any,                 arm64_ventura:  "8d40688785cb82a03168957ea8c8697c5c98ed4ba9fb9a6228ddf999844d3f9b"
    sha256 cellar: :any,                 arm64_monterey: "67e077b4c0f9f5c17c8c92b3a387068c5473b1ad7c7ee223ec9714cf4a914310"
    sha256 cellar: :any,                 arm64_big_sur:  "bc8ebe163bde63ca15e94de26ec4ca3c784b4a66a7a619e30cfcb57f395ab81a"
    sha256 cellar: :any,                 ventura:        "a1e7d6cf2528f388ca4669a532ded945e89b5e3da484776b2a5a04bed8d2c331"
    sha256 cellar: :any,                 monterey:       "2a481f104ec3d1044aed6eca5d368a512f18d48580d9f4f07680fa31726f07f0"
    sha256 cellar: :any,                 big_sur:        "638f6f82d855ce93a57edecb49e78dd889ce224c769ce83dff65f8ea404096fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62855f0c6dc143835fe0af6196cf06d4d38c239e6647153d361409cd5282ea9c"
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

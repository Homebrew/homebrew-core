class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/refs/tags/2.226.0.tar.gz"
  sha256 "dab7c2f3d8cc47e1bc4ed8b4351a0e1b438c70009bb28f3e352ffbb5c001b1f9"
  license "MIT"
  revision 1
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d4c54b581214943be2f5e8063a9b1ef9ff1685a86bd8d0db0d665f8068e2f35c"
    sha256 cellar: :any,                 arm64_sonoma:  "98749c5e08c615bedc1dd2244fb90573b869b434f2705c6bcfb3e2b7c3adc1d0"
    sha256 cellar: :any,                 arm64_ventura: "2d41ffe353ab6bd4ce27706cc46cddec1142638ad13c8ee1ff0c14fb80c95864"
    sha256 cellar: :any,                 sonoma:        "c012e9f78fb4b08f068bc3082e36cd83688b717bfab325a27f82404cb6a7ed6d"
    sha256 cellar: :any,                 ventura:       "292ef02ff9752fde13846171cfbf381028226c79df17481e171ad45a60de5522"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e72c513943982423660260daa61a9533c553ea4498cda613c2bfcf109fd33b8"
  end

  depends_on "ruby"

  on_macos do
    depends_on "terminal-notifier"
  end

  def fastlane_gem_home
    "${HOME}/.local/share/fastlane/#{Formula["ruby"].version.major_minor}.0"
  end

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec
    ENV["LANG"] = "en_US.UTF-8"
    ENV["LC_ALL"] = "en_US.UTF-8"

    # `abbrev`, `mutex_m` gem no longer with ruby 3.4+, upstream patch pr, https://github.com/fastlane/fastlane/pull/29182
    system "gem", "install", "abbrev", "--no-document"
    system "gem", "install", "mutex_m", "--no-document"

    system "gem", "build", "fastlane.gemspec"
    system "gem", "install", "fastlane-#{version}.gem", "--no-document"

    (bin/"fastlane").write_env_script libexec/"bin/fastlane",
      PATH:                            "#{Formula["ruby"].opt_bin}:#{libexec}/bin:#{fastlane_gem_home}/bin:$PATH",
      FASTLANE_INSTALLED_VIA_HOMEBREW: "true",
      GEM_HOME:                        "${FASTLANE_GEM_HOME:-#{fastlane_gem_home}}",
      GEM_PATH:                        "${FASTLANE_GEM_HOME:-#{fastlane_gem_home}}:#{libexec}"

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

  def caveats
    <<~EOS
      Fastlane will install additional gems to FASTLANE_GEM_HOME, which defaults to
        #{fastlane_gem_home}
    EOS
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

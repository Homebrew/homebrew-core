class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/refs/tags/2.225.0.tar.gz"
  sha256 "1cbe6d1f65d17df7d6e546d7c44539c7859258d9e0b1d879c2a5cad8418a17f2"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d08573cc0c92e784eb522b5fe9b09a10e25be6d4d9def337898128ececd06458"
    sha256 cellar: :any,                 arm64_sonoma:  "ec46c7590e7e5dbaf039c8da0f8314cf927ff0f07a69fe08f86129e9d0b0b3d9"
    sha256 cellar: :any,                 arm64_ventura: "0be7fcce1a104b88819cccff28131270f0ca1ee4d3e7452c27700417cfa768ad"
    sha256 cellar: :any,                 sonoma:        "1df4e5dbcf77b482846db30400ed097fa16c711696eb1e10a4d961628314929f"
    sha256 cellar: :any,                 ventura:       "f30bef6bf557e174e309bbd4c477bc1534868a02b7f27415687399491184d573"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da628b7772479bf2db8fba92b7cb363fb87d3d8a5c51f1686cfeb378eb69bb77"
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

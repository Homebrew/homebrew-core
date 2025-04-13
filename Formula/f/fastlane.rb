class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/refs/tags/2.227.1.tar.gz"
  sha256 "c0cdbb327c690b96d80390b11a5743acb09278769e87409e8afde9741184d8b3"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "361a379b06591337a92d2a12d5fac773da7573986c108f0d1e6dda89d8734d27"
    sha256 cellar: :any,                 arm64_sonoma:  "53e065bd28bb6e8285df9cc3807a4297ea3fb5ee9b05f3cf962626d61361f7a4"
    sha256 cellar: :any,                 arm64_ventura: "cb7c5d3e66036acb71b098475f61795f47b24b13251292139ea77ae422fff324"
    sha256 cellar: :any,                 sonoma:        "109582e4a81e6d92c432283b70185671dce4ce8666038f09ccbd47b966418a7c"
    sha256 cellar: :any,                 ventura:       "191e2abd525d891ae4422fb6eb852352d6bac225d0a96d36d857a4bc71bb30a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "319264480942c61179880cdc6fd7930425c06594a4a20e5db25d2a95c4ab9b06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4033e3eb0f8f88039839795bc740aff082b6980c6529953595111abc4e5d02f5"
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

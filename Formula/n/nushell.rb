class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/refs/tags/0.117.0.tar.gz"
  sha256 "ccb5640f8f88b48787c946daf87a349972b939c2edbc5a3b4ca6fc0921bddd6b"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6140577dbc3fd54dfef8b8a74d7952be152d1fe780389fbd9361e9d4b3e994c6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ac90b102a7fe43b30d6aa75f560680d4fb29c9e76d6456942adf14fd41f9685a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c3323239e4bf69c8ef9ddc9f67a92d4d335dfe8c8ef13a647779f6207edc0cbb"
    sha256 cellar: :any,                 arm64_linux:       "47488a0bc802e4f8229543232fc4c8b50a06ea3335556f541c48920dc66b087a"
    sha256 cellar: :any,                 x86_64_linux:      "5f8609e016e389b0af8cbd788629ca3db7c41fca3edb5f0264bce23f8c107926"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  uses_from_macos "curl"

  on_linux do
    depends_on "libgit2" # for `nu_plugin_gstat`
    depends_on "libx11"
    depends_on "libxcb"
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["NU_VENDOR_AUTOLOAD_DIR"] = HOMEBREW_PREFIX/"share/nushell/vendor/autoload"

    system "cargo", "install", *std_cargo_args

    buildpath.glob("crates/nu_plugin_*").each do |plugindir|
      next unless (plugindir/"Cargo.toml").exist?

      system "cargo", "install", *std_cargo_args(path: plugindir)
    end
  end

  test do
    assert_match "homebrew_test",
      pipe_output("#{bin}/nu -c '{ foo: 1, bar: homebrew_test} | get bar'", nil)
  end
end

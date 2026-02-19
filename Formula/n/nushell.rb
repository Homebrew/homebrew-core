class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/refs/tags/0.110.0.tar.gz"
  sha256 "e4c95f743cea3d985ab90e03fd35707a46eef926d407ed363f994155c1ca5055"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "9a1ba65f7bb0701d5a8e8ae0152db1c362661028b6c2e449328106a61f0e6876"
    sha256 cellar: :any,                 arm64_sequoia: "16107880812389688aac15411f789b86c97085358e02c6421929bb121ff42c9a"
    sha256 cellar: :any,                 arm64_sonoma:  "258ee8b792764fd907e405e0aab0b694e378cd0135bbb72410bb34d64e08860d"
    sha256 cellar: :any,                 sonoma:        "a563fd2e109f789611ce3b1e73667fcf69191b08eb549ef1f059818ae26daa4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29862de9f289e6d3438f3c8e0401d32510953cd40c404e9f4d99c51b1c19ae64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3f3e8b78e2e6756662d2bbf645da7a09e54aef5f5e6e316f6914b92b94a677d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"

  on_linux do
    depends_on "libgit2" # for `nu_plugin_gstat`
    depends_on "libx11"
    depends_on "libxcb"
    depends_on "zlib-ng-compat"
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

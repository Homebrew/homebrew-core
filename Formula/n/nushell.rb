class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/refs/tags/0.112.2.tar.gz"
  sha256 "32ebcfe41b6390145e90eb86273e221f22eeacd53ecac5274405f148fb4258c2"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "373560623fa162fee96124c8449a44b3275716ae539d604334937a8d56da589c"
    sha256 cellar: :any,                 arm64_sequoia: "41d194f3a9e4ff91e63dd2285bff2168db5cf245d0f55b74539584808bc63bdb"
    sha256 cellar: :any,                 arm64_sonoma:  "ca4d1838d7046c97d58334650bfe050859282d0cef7d8864f47dafdf95a224a4"
    sha256 cellar: :any,                 sonoma:        "2de7bf5a2c36c93d24793160aa73aa8e58c4bb83c93b33503e437dc1d246f387"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e40194648b8f4cbc582ddd6b3fda9b4a0f7532b020f717a6f1d1f41450d63a2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2abe66b0e3468b0c5dd40a54c5929eb2bbf615144dad3181d15da948193aa94b"
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

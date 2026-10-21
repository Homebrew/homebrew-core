class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/refs/tags/0.116.1.tar.gz"
  sha256 "0cca0c5bc9d9eb608dee00c75b6b511917df6e66c784b034468bab2ff0fbb9b4"
  license "MIT"
  revision 1
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d18196a0a8500ce635f118eab3f3d6cbf8459042a22d3fa123d7cf466379a86c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4c2f83ab98dec74d69d142f1de6630c39c9a5f2d3ab53dceece1bb309d0d647d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "565e6bf6e0e8fc13e8cf898465b942d575aae19fdf9b47ecfd67c77bfa6e1b71"
    sha256 cellar: :any,                 arm64_linux:       "a138bc04782c9c0c761a0f8b75422d2fe5fecb930445f1dad971e6ce4ae2aa00"
    sha256 cellar: :any,                 x86_64_linux:      "d8c5b15f24e509634e7b634fda6bbf4575288933ccb131365741344efd323791"
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

class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/refs/tags/0.102.0.tar.gz"
  sha256 "97faa3626be944d83b26c43d0b5c9e1ae14dfc55ef4465ac00fc1c64dceda7ce"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "80fc5e6a175f9a3dbc4ce1d275f9f1781499bdedc703893a506a3e3b0a6382d0"
    sha256 cellar: :any,                 arm64_sonoma:  "850d39257f3b24e35fde7bb02225bb964c0427ce58c087a08fd2126b00b83215"
    sha256 cellar: :any,                 arm64_ventura: "8eebaa2fdd6a1c0047a707d508779c5a5a671e9044d6ece39af75a2f825e8a99"
    sha256 cellar: :any,                 sonoma:        "7a66f7869a72d8eb9bb6ca9bac701f09425311be5be4750581393829a5e27f96"
    sha256 cellar: :any,                 ventura:       "2f040bfdcadafb40e98d6ed04ce767653b29556c707f95396132125e135b1938"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3aaee1b4acbde109639cce949af39ed6e8083b8546c2aea78d6d199fd4c7d5f5"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "libgit2" # for `nu_plugin_gstat`
    depends_on "libx11"
    depends_on "libxcb"
  end

  def install
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

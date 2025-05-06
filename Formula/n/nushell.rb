class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/refs/tags/0.104.0.tar.gz"
  sha256 "2964ef7148d0f67fa4860fa3eab1c7d15c51ec5292be0cd0865996816f46fe84"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1262513559b84e8f818f3389e8c36dee5d0ceaab8db24926ec9527383f412dc5"
    sha256 cellar: :any,                 arm64_sonoma:  "86c404706c73487df9f2cbb8db52485696915d17425c1a55c71b6f16ca27f5d1"
    sha256 cellar: :any,                 arm64_ventura: "090650105b09f896f1dad6866b1572874b40c2b69b7d4509bfe32f50a230e6fc"
    sha256 cellar: :any,                 sonoma:        "88b286ab8c4ab3608d952b507c74e0e7212ed3be9ce32c34c1ca804a8e37bc43"
    sha256 cellar: :any,                 ventura:       "ce3f3dc6f3c22dc2c94bc8cafd6f66c8685db02fd9f1ba6c0d3c333d8e1b9843"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94e3a3a5e15e2acf70cfc156479b15af9c2c4698a1b217ec6f147f64969d6044"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74df9f405ca0e22317fa1efe0ddfffb7a62ab2603b375a9f35a46aabd3c10e61"
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

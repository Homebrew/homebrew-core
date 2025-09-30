class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/refs/tags/0.107.0.tar.gz"
  sha256 "e5b91463b915c26e72a7be48ddac411e02e25daca1887ec4cf7b98b3b4e6e72e"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3a16d570c0612c8d70a5cc0fe183ddea0b6bf5ef8b962a13c3ac0d225ae6bc4c"
    sha256 cellar: :any,                 arm64_sequoia: "8f65b1a9b626946b1a739e2fa804dddeeb8b0d6f4444eb410789f7da5b787fae"
    sha256 cellar: :any,                 arm64_sonoma:  "dda8e94c920405e2dc46738ccf60fc9794c815af0e8c13675d70adbb3dfd7c90"
    sha256 cellar: :any,                 arm64_ventura: "b383d2551a6c8e6803224f1fad53cfb3b606147679155be323a16299ec52380b"
    sha256 cellar: :any,                 sonoma:        "2a9f914109e0566641ba7ab87667e0f661a590b22f54c978b684f07f632bc036"
    sha256 cellar: :any,                 ventura:       "1217e25d24fbfc3d6fee0f7dca83f4e35ed04c5599c027f9b4aae6a8eab6715f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35b011f1298b4ad2689919e1d7eb1c3554c0fd026a91c2bc095613c556c57c0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e287584ccf78a8220cb163851e1cf9e4f848b6b7ab7da425e2f643d7286bc72f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
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

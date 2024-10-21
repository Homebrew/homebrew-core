class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/refs/tags/0.99.1.tar.gz"
  sha256 "2d7c779b90e6382516db74d2a4b902764ae4e739c4b1b0d615521c7d8082c0d5"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "09e3a9ba7fb307221ac4d35682167bf4a183d6d9ca72a3e35298d5579440e0fc"
    sha256 cellar: :any,                 arm64_sonoma:  "236e26d099fddd37abe65a25dfd88df3d60edef4856d71d2895b1e44870ca195"
    sha256 cellar: :any,                 arm64_ventura: "c88745fd444f60976163c53d4a2678957388f5cb5f0c394b30d4ebbd84abb984"
    sha256 cellar: :any,                 sonoma:        "1dcef691ed9099af09668c21d50234264f4b89383c4bf8fa447dfab45ef4985f"
    sha256 cellar: :any,                 ventura:       "780b4e8f07a31f92816c4ea2d67eeeffd5e1a5f2dad1889a424b605329a6fccd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5547ca0016dd5d3f4dfb4b4474e58dcfd91bf7a089a2837d66b10c86ee79c211"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
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

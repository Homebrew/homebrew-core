class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/refs/tags/0.91.0.tar.gz"
  sha256 "8957808c3d87b17c6e874b8382e8be45100e83c540556b2c43864c428c2b80b5"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8f820381a2cc6147e3fbbd81b400c4fae6800251a84133dd175e43cb356191b7"
    sha256 cellar: :any,                 arm64_ventura:  "37a0266128bd05192eda3dfc1df0737ccacf23445abc9f0793bd584c53045766"
    sha256 cellar: :any,                 arm64_monterey: "452993b30a1d09b2000b027f86d0e459144023cd22bd7a6b852ee2f26ac91eff"
    sha256 cellar: :any,                 sonoma:         "80b8429a8c6feeec0c600ea9b3c09799fd88f51330719a94111fc3b12153edf3"
    sha256 cellar: :any,                 ventura:        "2154dbccafa813a101caeb53d3b4e629d8c04cd8dc0ad7b05071c01ab5c98012"
    sha256 cellar: :any,                 monterey:       "4ab07f9ad820a55c34e2b4f3f2d091dcfdc6621c2e97581b13587da9150c424f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1758c7829be780cf751adb71a15125dc057f1735b4e616807564a39156b69e6"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libgit2" # for `nu_plugin_gstat`
    depends_on "libx11"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", "--features", "dataframe,extra", *std_cargo_args

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

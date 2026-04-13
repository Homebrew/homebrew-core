class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/refs/tags/0.112.1.tar.gz"
  sha256 "92e393999fcddcccbe93c8ea5fcfa53839d9201187c0a28d0cd1ab1a8e7187af"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "662e861de4e815405375f2a7e0d449de5da802db023c44a3d415be042951b99a"
    sha256 cellar: :any,                 arm64_sequoia: "90a3043e50b625c02439e7d09cc97316528aa44b3da157dedc02bc9567e6b9ef"
    sha256 cellar: :any,                 arm64_sonoma:  "3905a687183acff2a0c5a12332a9c632d5b8744f37ab12d924b346c854237ce6"
    sha256 cellar: :any,                 sonoma:        "3dba7d16e2566d39ecca217adef255cf6c56219666f9967d7a344391d13b81a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09861e4978975b825a7003620073d99bd31a20a0c23f3df357ce6902d3e19ee1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbc13e2b71055c00093dfab936571de096ad4917e373d93b0c56afa4adba3e8c"
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

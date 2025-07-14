class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/refs/tags/0.105.1.tar.gz"
  sha256 "2c52ef5aef2ba1a3ae873e84bf72b52220f47c8fe47b99950b791e678a43d597"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e2ed65e85de69f990bb670b00a12b813b705d04f42b4896149f70dd4c375f445"
    sha256 cellar: :any,                 arm64_sonoma:  "2ffbe28e45e386980cb861d928d04245d5970b9678032e90071b96a9b4b0ec6c"
    sha256 cellar: :any,                 arm64_ventura: "6a9683c1e59dba3d31b0b8f5a83bc1cd5789a7f89a4a8d9f830a37aaceb19457"
    sha256 cellar: :any,                 sonoma:        "151497d52b06e4574c71dc687cf06f1a79b5a7a6af64a6a7dd1d404260691c69"
    sha256 cellar: :any,                 ventura:       "61c10fe3d29d1db968dc982cdc9e19b0fe137457d819e8a2825061b4ebe795e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1840d6b340b1e29e306d53ad7522ec6471949eebd14e1a4aa5ca6cddd6234e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acd14e16853bdb98c51f0da288aaf45f499fd7fda965fbc7787dc04f66083925"
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

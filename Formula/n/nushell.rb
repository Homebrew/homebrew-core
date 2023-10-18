class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.86.0.tar.gz"
  sha256 "733576c766f087e4fdabee14bbcb0ba15516472d4f443fc401386cd1d6e8d7eb"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f97657886066b7ceaf91d3797e55d52fa4eade3a5e815d2b7ce71ac7a69145d6"
    sha256 cellar: :any,                 arm64_ventura:  "7fb67764588b27fe9d1a3919c4a0d2b55531adb8dbbde73097e08e0a9fb34ccb"
    sha256 cellar: :any,                 arm64_monterey: "d24b2cc5140d15400325edcc332f62eaef92291e63b2957d3ee4c59d069c219b"
    sha256 cellar: :any,                 sonoma:         "888ba50c6aee106b2fd6bed0a5529358e74925d2a2aa822d8b815f70a601e4bd"
    sha256 cellar: :any,                 ventura:        "5331917c2f681ba0013684eb100d55f44c228073e83c4d949caa15a2e776ee5c"
    sha256 cellar: :any,                 monterey:       "8ea201ade198d1fb86aeb0d454170c076abdfce9098665ad8a5eebc6b0213395"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6010735b20c07a5ed6de739d8bc0fdb1f21a6682b5668d7e1eb0a1704fd63ff2"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libx11"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", "--features", "dataframe", *std_cargo_args

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

class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/refs/tags/0.93.0.tar.gz"
  sha256 "00dcd5ab112d8afd683aa0b87b65b2e47a45487857a6d2481ce7eeb0045c2c00"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c75ff6454132e19a6956ee572cf7df69bf33aaf1c7e6b629f72fdaf2d8015db9"
    sha256 cellar: :any,                 arm64_ventura:  "5f51fc122c7683ab82269491e4ef6c66db2ccb6bc45dbc26ac220dbe8ee71d41"
    sha256 cellar: :any,                 arm64_monterey: "db0816a6a2d9d8afdae9ba06220b1d33bd8771497059a69126d4ec71b21b22bc"
    sha256 cellar: :any,                 sonoma:         "18a5478168f82700a29f9fc1edd13675329a0490b852a0ba39ca495506a2219e"
    sha256 cellar: :any,                 ventura:        "6fe2703715c43ab873632d3b4189537e45687f95150ded2bb71e9c957a5a0b39"
    sha256 cellar: :any,                 monterey:       "e235315526b51a98410f9a2df8e79e9b0d184c2417ed77ea317322fffac3dad0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f67375f753eee29b763695b6ab4551ff76d7f874ad75bc7e1eb36594a92c4ef"
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

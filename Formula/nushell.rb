class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.73.0.tar.gz"
  sha256 "02e63edb99e50c32a334a157bc82486990aebfd6bdae03d6852c30612bb39c22"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "41ea6f981ccb71645c5cd6e9fcf05a0608b8b7127f4fcf05d2aaf0fe2d05a46b"
    sha256 cellar: :any,                 arm64_monterey: "f235fda5e30b37c873cc7a3a2d94eec7dca223dd08111598a2357a00dde75028"
    sha256 cellar: :any,                 arm64_big_sur:  "c801edd911fe10dec62e1211fcba46074e74e689a29809ea0f81fd693b6db1f3"
    sha256 cellar: :any,                 ventura:        "bd5db54c795b11b91317db7a08ba2d7e7df4ebd68f88566ec31d035381129537"
    sha256 cellar: :any,                 monterey:       "185fee6b750804ef58e750dd28d4a17fe896f733141f77ed81d8a55cad81cc0e"
    sha256 cellar: :any,                 big_sur:        "be1b4573e4ce0944a477bb2e5e5f277b4bc6c81b2e0629d1a07415c7f9c3f87d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3fda17d85619441fffbe52a61ab374c270309aa4529d638dac27e19feee7cd3"
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
    system "cargo", "install", "--features", "extra", *std_cargo_args

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

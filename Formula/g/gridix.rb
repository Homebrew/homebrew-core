class Gridix < Formula
  desc "Fast, secure, cross-platform database management tool with Helix/Vim keybindings"
  homepage "https://github.com/MCB-SMART-BOY/Gridix"
  url "https://github.com/MCB-SMART-BOY/Gridix/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "fb4cb7114bd1a652ebfbef30229a88f7265abe94ede8c9e5ee3d1c0490476dfd"
  license "MIT"
  head "https://github.com/MCB-SMART-BOY/Gridix.git", branch: "master"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "gtk+3"
  depends_on "openssl@3"

  on_linux do
    depends_on "libxkbcommon"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "gridix", shell_output("#{bin}/gridix --help")
  end
end

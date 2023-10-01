class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.85.0.tar.gz"
  sha256 "19e327b23fc08b519f5077e33908afa7967d98139a516c180d029b3ca0618da3"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b473a1f6e806247f01afe3c907c514ffef96db7a16a28d1f4870f4fd7dee42ee"
    sha256 cellar: :any,                 arm64_monterey: "8e17bd501d26b77daa3dd1b4910f2a5759705b4f11326eb8f4f4bece7679c738"
    sha256 cellar: :any,                 arm64_big_sur:  "343dcb2b288eefc9710f52562e36e5de740051c9898d5b5d61d62266a30f59d1"
    sha256 cellar: :any,                 ventura:        "b80decf0eb340e468f011943d2d4cc5bdaebc1786bb7f9e333fea73f98bdaeb6"
    sha256 cellar: :any,                 monterey:       "fbe4773018c4458639cef9229f662f3182da100ce204ca4a4b48afdfe0fb732b"
    sha256 cellar: :any,                 big_sur:        "5580df6b5e68efefded9eca82782f95e76d99b4d28f049f3360a5a26ebc53717"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53c84f4908d38c90735b48508b11c2da535d401c16d61df7fcd70a978bca66f8"
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

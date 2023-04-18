class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.78.0.tar.gz"
  sha256 "eff55bf4e0739113cfdc890c0ed90f46ebbfd722b49f7ce65e76b347733bc654"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "48786d786a9f68cddf1275abb1f4f0e5df914bfdb374f477a7a37b4da0310369"
    sha256 cellar: :any,                 arm64_monterey: "68c018de5a2a37031d0f480faad8150a3db652949c6c52d4d3635646badb664a"
    sha256 cellar: :any,                 arm64_big_sur:  "359f4f5234e7e7cd09e2a00c2697503bdf5ebca69e6cc0163ce3c51f9e67c07c"
    sha256 cellar: :any,                 ventura:        "a41b2c8da9a657ee998a9aadb051bd9364ce7c2ae863caf451b72993deac2ccd"
    sha256 cellar: :any,                 monterey:       "3fc0efc119a40f827a2898244e6ba991ff22ac871833680909e15f76b7f60bf2"
    sha256 cellar: :any,                 big_sur:        "3f3596ac8f380342aadda25c129ca02dbb8c628cebb8e027e5c8116e56a62b13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "339dbcacfced3d7e06e9ea5f065ee609b649285892c94afd45079182a17a4de2"
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

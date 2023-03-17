class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.77.1.tar.gz"
  sha256 "37b767351e1a15ca59988f2257d61a52f035a35079e8a304ff59448a46190df0"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6f15b6d841ddc6d137fac4393d4c5d438a63b79b34d2845e1618eca5cac452fe"
    sha256 cellar: :any,                 arm64_monterey: "8c4cc34ddeba4955ecfafee7ff6189f25361e2eda1ba73f04767233742723a1b"
    sha256 cellar: :any,                 arm64_big_sur:  "b44b155f8f9a1b4cae7b94e9f9a451c0099b7fa4f49233b0e928dd5f9cf97381"
    sha256 cellar: :any,                 ventura:        "d57249492afeb225c6a049b5111af1255fcf59b12ce1cd567492c9798b22b7f0"
    sha256 cellar: :any,                 monterey:       "556c21515f8922fc91fa55330494dd11444beb4e2016f639f1783e793cdc7b09"
    sha256 cellar: :any,                 big_sur:        "97a7e8e5d8725026433fd5b4b85bc0aec9309992a94ba8d98fc7ea3f550eee94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c42a327ec74f3b2b85f1c583bf553f0fff55ebab25d341b5f59edabdecf542c9"
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

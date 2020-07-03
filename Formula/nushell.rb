class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.16.0.tar.gz"
  sha256 "ba596706bfdb58d10f1185ae0f9cd0988ab77a9972daefba5c93306f6ed314d6"
  head "https://github.com/nushell/nushell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cab65dc4a1aaa49c1c46fb2bf20efbaec4bdca1714b1fc1151fde7fe55d20550" => :catalina
    sha256 "cbb0c4a390446a75278ac24f61ffa6778ae930f289876d18a22fe742b9ef9058" => :mojave
    sha256 "3f0bc08545bc91d89b8ca6499ae714b11b5d397e6812e1a490c0bc7722005989" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", "--features", "stable", *std_cargo_args
  end

  test do
    assert_match "homebrew_test",
      pipe_output("#{bin}/nu", 'echo \'{"foo":1, "bar" : "homebrew_test"}\' | from json | get bar')
  end
end

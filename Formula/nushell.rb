class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.30.0.tar.gz"
  sha256 "a36cd3d93c69aab83c874fe0c8b653ce9fe188da9f527d3bb28492ba213e579a"
  license "MIT"
  revision 1
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0c953b0b2680e60ba759340b3ed67c0cfc9c5d2d37537295cf1cb29d1bd51fc3"
    sha256 cellar: :any_skip_relocation, big_sur:       "3c8b74d01c3bf5c5ebde96351049640dee37e7bd483d63943902d7425df7ad12"
    sha256 cellar: :any_skip_relocation, catalina:      "1f270e4152e65cbf75832d22fc4edec5dd6564cbfaa6e1d1ba13e25b3cccd8e0"
    sha256 cellar: :any_skip_relocation, mojave:        "4e0ee5c708926fe52a75d1cc636ad06fc278ca735919db749b17fcc2ae011bad"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", "--features", "extra", *std_cargo_args
  end

  test do
    assert_match "homebrew_test",
      pipe_output("#{bin}/nu", 'echo \'{"foo":1, "bar" : "homebrew_test"}\' | from json | get bar')
  end
end

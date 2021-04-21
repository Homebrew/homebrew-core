class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.30.0.tar.gz"
  sha256 "a36cd3d93c69aab83c874fe0c8b653ce9fe188da9f527d3bb28492ba213e579a"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "aac6763146aecb86d8380b9529f1faa7120d5fea9325e1a8dac3d451dc21eecb"
    sha256 cellar: :any_skip_relocation, big_sur:       "05e95f943a3c59dbc3b08436ba21aaadc606d8e8c03bc1650bc8427a575ac2ee"
    sha256 cellar: :any_skip_relocation, catalina:      "87f350cd6fce9633c2f0abce86fc6ab7f216ca5a47f8d9c9a8dbc737e47ecd46"
    sha256 cellar: :any_skip_relocation, mojave:        "6b2665736f8a1b9114b1a5abe0ae13c6b2fb1a78b878bda3156ca9459984262d"
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

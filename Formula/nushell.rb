class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.12.0.tar.gz"
  sha256 "f6bd3b36722b2edd7a89b945c3e9d91dcc1c32e472ba82f61816c65b0083cde0"
  head "https://github.com/nushell/nushell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "11b4716e3fec8d185bf81278b4be3e5c997b9cf5ee08b186416dc6818b09fef0" => :catalina
    sha256 "9365cc66a4775a8cf9e861ac32de03a572ee59c47e45bb66faeafb7d6ce33630" => :mojave
    sha256 "c64edd2d9e4bf9b6de9b933fbb9111d5012f8bceeb945d7d13103ade89751402" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--features", "stable", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_equal pipe_output("#{bin}/nu", 'echo \'{"foo":1, "bar":2}\' | from-json | get bar | echo $it'),
    "Welcome to Nushell #{version} (type 'help' for more info)\n~ \n❯ 2~ \n❯ "
  end
end

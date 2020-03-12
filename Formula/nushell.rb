class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.11.0.tar.gz"
  sha256 "75f4c3785c863db75c7f6d49e479c69e50c51daacb0bb76527fd632d7bd362f1"
  head "https://github.com/nushell/nushell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dbe8943f8393fcf94cf9db08b886628b1cb59f096141b8f959814d9ed1f36b76" => :catalina
    sha256 "75750391cb2dff2d1d62d2a4c1eed4f43d619365e8768785c79045b2d2bb1dfb" => :mojave
    sha256 "0996afd276eaaba984c77531d29009999c66351f507d7e47e5bf1eea3952f923" => :high_sierra
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

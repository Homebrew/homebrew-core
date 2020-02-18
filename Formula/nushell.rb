class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.10.0.tar.gz"
  sha256 "8e08dd1a9d25a67ffcfb32a9c6de8bfde5f797b74c44935e553db65fcd848497"
  head "https://github.com/nushell/nushell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "68d7a645de974b7292c466cb315a3de39476b3d53e62b65c8b578ce26c287f32" => :catalina
    sha256 "70742b0540b891a7885470d386bee8e7172e0afc34c47cf36daa81890881d5bc" => :mojave
    sha256 "ac51a08ef78b3ac2ff2045bbef6ee1bb57db3b428af47ee60df783e93be7c69c" => :high_sierra
  end

  depends_on "rust" => :build

  depends_on "openssl@1.1"

  def install
    system "cargo", "install", "--features", "stable", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_equal "Welcome to Nushell #{version} (type 'help' for more info)\n~ \n❯ 2\n~ \n❯ ",
    pipe_output("#{bin}/nu", 'echo \'{"foo":1, "bar":2}\' | from-json | get bar | echo $it')
  end
end

class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.14.0.tar.gz"
  sha256 "8084bb21433aa3598475470abf78e6653440b51db2f28392212eee00238c3346"
  head "https://github.com/nushell/nushell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f4c3ea588dd7578d63e5fb3cac4effa54a663fc267652b62a28ba9d131a3bc3" => :catalina
    sha256 "aae3eabe041dded3b75543c9ed9bf640d447ef6d7e8700134df95bd0689f768d" => :mojave
    sha256 "355bd7c50f4898e1bd4ef0562410022afee9dbfaa7cbb5df95761b87694e37bc" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--features", "stable", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_equal pipe_output("#{bin}/nu", 'echo \'{"foo":1, "bar":2}\' | from json | get bar | echo $it'),
    "Welcome to Nushell #{version} (type 'help' for more info)\n~ \n❯ 2~ \n❯ "
  end
end

class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.13.0.tar.gz"
  sha256 "a07f730fa5dfe96ea3104b1cc13d2e72951a754870f22fb0dac6e30a359c6d8e"
  head "https://github.com/nushell/nushell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fff948e9de5f43c5ee089233aad6c635a70d5c6ba428a6030a19af8bda6e161c" => :catalina
    sha256 "625c2d3f4d2cc413437bfccce122091b59e32e55ac395f545f8a10ffe70d3332" => :mojave
    sha256 "ff9750f92f76d33b6801f1c1930db91c9d60ab2514fb5704ddf962bc469950b5" => :high_sierra
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

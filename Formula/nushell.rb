class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0_5_0.tar.gz"
  sha256 "46c9c0ba95c464c70c8a4c099962873e5baa1b9bee3413645a0cc245701047da"
  head "https://github.com/nushell/nushell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5d3ab54e316a73444fd7b085cb25401c5343eea108fa2eae69596d15b5389fb8" => :catalina
    sha256 "457352069235445d0e135b215d88c432c258c881798794daf7aed5a92c774463" => :mojave
    sha256 "eaafd3f5474f4c4cf77d7a89e5cb96e3eebd94d5f16c5f8ad81871e1dfd51dc8" => :high_sierra
  end

  depends_on "openssl@1.1"
  depends_on "rust"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    # assert_equal "#{Dir.pwd}> 2\n#{Dir.pwd}> CTRL-D\n", pipe_output("#{bin}/nu", 'echo \'{"foo":1, "bar":2}\' | from-json | get bar | echo $it')

    # Remove the test below and return to the better one above if/when Nushell
    # reinstates the expected behavior for Ctrl+D (EOF)
    assert_match version.to_s, shell_output("#{bin}/nu --version")
  end
end

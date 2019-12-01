class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.6.1.tar.gz"
  sha256 "3f7878df7d77fe330e6840428845800d9eefc2ad8248617c42004030ecf527f0"
  head "https://github.com/nushell/nushell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fe7d8bb7afc14616f3513d1d4cb2a615ebd2d63460d020f5d7d732e14ab6ae7a" => :catalina
    sha256 "2ebfe6d0b3364c8efa9f308a55724eeaceaa2d40e7a89d63ce6274a57ce8badf" => :mojave
    sha256 "b00815e1b2dee7798a79b357a1afc9c203cc49037d1da39051184ef9a1cf4f53" => :high_sierra
  end

  depends_on "openssl@1.1"
  depends_on "rust"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_equal "#{Dir.pwd}> 2\n#{Dir.pwd}> ", pipe_output("#{bin}/nu", 'echo \'{"foo":1, "bar":2}\' | from-json | get bar | echo $it')
  end
end

class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0_5_0.tar.gz"
  sha256 "46c9c0ba95c464c70c8a4c099962873e5baa1b9bee3413645a0cc245701047da"
  head "https://github.com/nushell/nushell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d4472e6f82b1f9b0b8da4a59d641d56d8da15c2ba6c8b9069dad0c94fe0c93c" => :catalina
    sha256 "78e24987e5f9697452966b7476733d2125319faf9b9ee746c023769e3cdd92a4" => :mojave
    sha256 "3e06fbbb3fde18b3ebb2d1e6282a5b0b2eacbc9f29f0703db95c0173514bb13c" => :high_sierra
    sha256 "8a7835a0ac11682f9f4a95ec92db6617252bb3bb2295996a812f28b47af19002" => :sierra
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

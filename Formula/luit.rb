class Luit < Formula
  desc "Filter run between arbitrary application and UTF-8 terminal emulator"
  homepage "https://invisible-island.net/luit/"
  url "https://invisible-mirror.net/archives/luit/luit-20190106.tgz"
  sha256 "2b900f65ccdc38f8bfc11c6020069d055ba63fce6f90baefe8efc222a5ca3920"

  bottle do
    cellar :any_skip_relocation
    sha256 "3aafc250abb3e80b97eb19c4cd33760526086ce59c6c4609a75504e34a5b25bf" => :catalina
    sha256 "11e27c20be2a427608f074fdc2d42d7647dd78671cf8242f436441a15fcbc001" => :mojave
    sha256 "83411e2dbc25e9b93bff916334d2dbf4c0534deb526ac2369e878eb6bcd0cbcc" => :high_sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--without-x"
    system "make", "install"
  end

  test do
    require "pty"
    (testpath/"input").write("#end {bye}\n")
    PTY.spawn(bin/"luit", "-encoding", "GBK", "echo", "foobar") do |r, _w, _pid|
      assert_match "foobar", r.read
    end
  end
end

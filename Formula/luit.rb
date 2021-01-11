class Luit < Formula
  desc "Filter run between arbitrary application and UTF-8 terminal emulator"
  homepage "https://invisible-island.net/luit/"
  url "https://invisible-mirror.net/archives/luit/luit-20201003.tgz"
  sha256 "c948da3c8b163e8e8f23cbe1255e7f3fa234c48aaf470b201ce55a3ecb4ad985"

  bottle do
    cellar :any_skip_relocation
    sha256 "94866891c1da82fe283a81563f768a43d495c59db3fad393a717b7c5343868b6" => :big_sur
    sha256 "38af86812ee95b8b21a030503ccffe9c437af56cfa7d76018c9073fddbdb1ca1" => :arm64_big_sur
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

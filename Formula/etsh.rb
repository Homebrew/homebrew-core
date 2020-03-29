class Etsh < Formula
  desc "Two ports of /bin/sh from V6 UNIX (circa 1975)"
  homepage "https://etsh.nl/"
  url "https://etsh.nl/src/etsh_5.4.0/etsh-5.4.0.tar.xz"
  sha256 "fd4351f50acbb34a22306996f33d391369d65a328e3650df75fb3e6ccacc8dce"
  version_scheme 1

  bottle do
    sha256 "1bb2f2a1cdb069e4963cba22c6014894a61853644e840341e8fd01f1ca522ea2" => :catalina
    sha256 "61739a70a6927e119b9f27fe51e24a5bd14f3c5f8cfed1888d1f00682e68c9c8" => :mojave
    sha256 "dbe3c9f5881aa417660aec6e9469123dde475b33551f7207cb3cb7aaade8c16d" => :high_sierra
  end

  conflicts_with "teleport", :because => "both install `tsh` binaries"

  def install
    system "./configure"
    system "make", "install", "PREFIX=#{prefix}", "SYSCONFDIR=#{etc}", "MANDIR=#{man1}"
    bin.install_symlink "etsh" => "osh"
    bin.install_symlink "tsh" => "sh6"
  end

  test do
    assert_match "brew!", shell_output("#{bin}/etsh -c 'echo brew!'").strip
  end
end

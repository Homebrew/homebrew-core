class Etsh < Formula
  desc "Two ports of /bin/sh from V6 UNIX (circa 1975)"
  homepage "https://etsh.nl/"
  url "https://etsh.nl/src/etsh_5.3.1/etsh-5.3.1.tar.xz"
  sha256 "83ae656da0ed39555818d3ac80841757672e55802632f6877037bc89a476ec2b"
  version_scheme 1

  bottle do
    rebuild 1
    sha256 "2721aef5aa5cd1d4cf4e6bd97289f1bf5f441bb7d3871045b67612a39b6c56b1" => :mojave
    sha256 "dded9864f32e60a05557e6fc59011844fbc9652cb38fa4f14e61496dff0f8fb0" => :high_sierra
    sha256 "af8a9bd05dcd73c313762fc0a17622854983cfc1fb42b3ae858c6bdf2427c42a" => :sierra
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

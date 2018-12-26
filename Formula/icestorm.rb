class Icestorm < Formula
  desc "Bitstream Tools for Lattice iCE40 FPGAs"
  homepage "http://www.clifford.at/icestorm/"
  url "https://github.com/cliffordwolf/icestorm/archive/9671b760f84ca4006f0ef101a3e3b201df4eabb5.tar.gz"
  version "20181109"
  sha256 "583f8fafe21e0d69e730316a7d36459e6d49506d6557a8b11e1d048868a6c16f"
  # head "https://github.com/cliffordwolf/icestorm.git"

  depends_on "pkg-config" => :build
  depends_on "libftdi0"
  depends_on "python"

  def install
    system "make", "install", "PREFIX=#{prefix}", "PRETTY=0"
  end

  test do
    system "#{bin}/iceprog", "--help"
  end
end

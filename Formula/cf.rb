class Cf < Formula
  desc "Filter to replace numeric timestamps with a formated date time"
  homepage "https://ee.lbl.gov/"
  url "https://ee.lbl.gov/downloads/cf/cf-1.2.5.tar.gz"
  sha256 "ef65e9eb57c56456dfd897fec12da8617c775e986c23c0b9cbfab173b34e5509"

  bottle do
    cellar :any_skip_relocation
    sha256 "14a240b51f627599ebd4cbbffc27c52d40790c6537f91f20d978d6054e62571b" => :catalina
    sha256 "0cbd888d1a69516d55ce6572208b6adbdcbe9df7195199ac5d6e678e3e794f85" => :mojave
    sha256 "b94cceb52c7da6995ed4acd014350e6d9b1dbeb7d03b0c8f2256a12e7f520b01" => :high_sierra
    sha256 "5f37fd5ff05bdc66d21e9006f8907f1d19c92743bdffc2a5463251f6f681bd20" => :sierra
    sha256 "658dbcf6f4868922582db207b8713c8a9009bc99d3d976866ecfacbb9f95dfd5" => :el_capitan
    sha256 "4b4d294a9bd632f4daa07e643f7e33e3ffcf419d4df76c6656d2c688795f0d3c" => :yosemite
    sha256 "ea165ebb43cf7e6d55e34b43df6dc31bc3b8a3d5d3441cb4106630b168e8c90b" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.mkpath
    man1.mkpath
    system "make", "install"
    system "make", "install-man"
  end

  test do
    assert_match /Jan 20 00:35:44/, `echo 1074558944 | #{bin}/cf -u`
  end
end

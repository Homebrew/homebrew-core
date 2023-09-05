class Ol < Formula
  desc "Purely functional dialect of Lisp"
  homepage "https://yuriy-chumak.github.io/ol/"
  url "https://github.com/yuriy-chumak/ol/archive/refs/tags/2.4.tar.gz"
  sha256 "019978ddcf0befc8b8de9f50899c9dd0f47a3e18cf9556bc72a75ae2d1d965d4"
  license any_of: ["LGPL-3.0-or-later", "MIT"]
  head "https://github.com/yuriy-chumak/ol.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "1b59e0382b8aedc6dbbfd70aa23dbc40b5ab46f393e572daf3504d06935c6afe"
    sha256 arm64_monterey: "bf61e935696b0b2fedc393b470fa77c6c2a8ce3dfdf6ae78c960c2a5ba80bd2f"
    sha256 arm64_big_sur:  "4d609dc724775f28c0cbafafe24cad7c270fba3bc2bebfecc2de3dbe52ad2c00"
    sha256 ventura:        "8a108afd70e91e04caf9055a4d0812c84247a1d4f0d45bd105b825f9cedf9f01"
    sha256 monterey:       "0305e268f451d21f79e4313fb57af6e91e10800964ae4fd784f84b0b39b4cd44"
    sha256 big_sur:        "bb8e699af96aeb0c0e98d970b175aabd40ba95e587593da055900b51a211addb"
    sha256 x86_64_linux:   "b97fbaeeb79f73be05b95384b07d3f3f4970dbf1a14b84b8193439b31f4600df"
  end

  uses_from_macos "vim" => :build # for xxd

  def install
    system "make", "all", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"gcd.ol").write <<~EOS
      (print (gcd 1071 1029))
    EOS
    assert_equal "21", shell_output("#{bin}/ol gcd.ol").strip
  end
end

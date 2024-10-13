class Moe < Formula
  desc "Console text editor for ISO-8859 and ASCII"
  homepage "https://www.gnu.org/software/moe/moe.html"
  url "https://ftp.gnu.org/gnu/moe/moe-1.14.tar.lz"
  mirror "https://ftpmirror.gnu.org/moe/moe-1.14.tar.lz"
  sha256 "f4babd6ce0ae19516f983454fb20d32dff71ad316337ac6bf93a42a5ff209c9d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sequoia:  "2028254daf3ea1c11dd72a8a610a15888bfae96927730822db150c126c4f3bd8"
    sha256 arm64_sonoma:   "0de135b01234f6354fb00606af75d2e49a321cde092c48e7cee9a8a8949c9413"
    sha256 arm64_ventura:  "338d5a85cc8df7d059646a5990e9a5d1767f55d39f390eb8fe14bd829c66f8e5"
    sha256 arm64_monterey: "1474f3002a8bc09df542f2ba4fc1c3142386f44495dbd1cebcd2f04a8f98e70e"
    sha256 sonoma:         "15031eb41fae90bad00dab0e6073f0b0ab0bcc0fd411a69d1723b0d26b153e57"
    sha256 ventura:        "6b9c08a283e1f899dde3e5c84621dcb17b045153c95dc04b543f82b69dbbd575"
    sha256 monterey:       "fd3eb3a7be9435634ab9948ab1132652de14c8963062fcbd417dc8b425b18cc6"
    sha256 x86_64_linux:   "42d5b57b27eb789e643dc5ac7d8ac19820f076e9233f4eeaab275630e7579f27"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"moe", "--version"
  end
end

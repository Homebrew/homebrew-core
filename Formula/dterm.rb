class Dterm < Formula
  desc "Terminal emulator for use with xterm and friends"
  homepage "http://www.knossos.net.nz/resources/free-software/dterm/"
  url "http://www.knossos.net.nz/downloads/dterm-0.5.tgz"
  sha256 "94533be79f1eec965e59886d5f00a35cb675c5db1d89419f253bb72f140abddb"

  bottle do
    cellar :any_skip_relocation
    sha256 "0ee11ec243e1d9038a5f8d0ef86a00e5bf07af59be0497e8b8b677bf032bdc2b" => :catalina
    sha256 "d6d5d49c0e4da6bc6273bb8cffc0717daea8cad68346c34d9beedcbe0e5b24a3" => :mojave
    sha256 "85085f6142348852c9a5efee30a697fa6b31d9162807a256aee5100e50ff99ea" => :high_sierra
    sha256 "a0f9f7bfcadc790624975724244e30d4459e0eb3172dc2646db2b58f7643589c" => :sierra
    sha256 "6e18a2f46faa55e99fe070c7fd5e95940d66a5295f694605c9e90b416b577d37" => :el_capitan
    sha256 "353231f24cda3e48779652002067ac2650b0182f4e7f69fc86b059139daf4511" => :yosemite
  end

  def install
    bin.mkpath
    system "make"
    system "make", "install", "BIN=#{bin}/"
  end

  test do
    system "#{bin}/dterm", "help"
  end
end

class Pex < Formula
  desc "Package manager for PostgreSQL"
  homepage "https://github.com/petere/pex"
  url "https://github.com/petere/pex/archive/1.20140409.tar.gz"
  sha256 "5047946a2f83e00de4096cd2c3b1546bc07be431d758f97764a36b32b8f0ae57"
  revision 3

  bottle do
    cellar :any_skip_relocation
    sha256 "8f2af5b095cd7bd4c0817cb041d6ee69fc8581937e1905bceff3139d88cb6cf0" => :high_sierra
    sha256 "e877950886ddd5b024d60b9e0c6eb5eed4b94c5e1c00bc224573ad6b637fb77c" => :sierra
    sha256 "e877950886ddd5b024d60b9e0c6eb5eed4b94c5e1c00bc224573ad6b637fb77c" => :el_capitan
    sha256 "e877950886ddd5b024d60b9e0c6eb5eed4b94c5e1c00bc224573ad6b637fb77c" => :yosemite
  end

  depends_on "postgresql"

  def install
    system "make", "install", "prefix=#{prefix}", "mandir=#{man}"
  end

  def caveats; <<~EOS
    If installing for the first time, perform the following in order to setup the necessary directory structure:
      pex init
    EOS
  end

  test do
    assert_match "share/pex/packages", shell_output("#{bin}/pex --repo").strip
  end
end

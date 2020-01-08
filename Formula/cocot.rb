class Cocot < Formula
  desc "Code converter on tty"
  homepage "https://vmi.jp/software/cygwin/cocot.html"
  url "https://github.com/vmi/cocot/archive/cocot-1.2-20171118.tar.gz"
  sha256 "b718630ce3ddf79624d7dcb625fc5a17944cbff0b76574d321fb80c61bb91e4c"
  head "https://github.com/vmi/cocot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c56c078fce103138a45bd1c715dc3854b9eddf207575fada0e736b866d4f46bb" => :catalina
    sha256 "c5b0aa39597693d037438bd0f411965754539aaf50fbb2cb3b2a61082b6f4178" => :mojave
    sha256 "0070eb38e06043e3c1a4ad1b77205a6ed978ed300e8d0bb407391fecb191b050" => :high_sierra
    sha256 "a91ba93032e33b6a062b82f2df0b9170d5269cf0312d75eb6f16341fca54f9bd" => :sierra
    sha256 "60cbdadb074b019535319e5089d5c55c43b68e0b52a73b01cec3a9a8311e51a4" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end

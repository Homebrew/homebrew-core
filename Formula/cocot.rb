class Cocot < Formula
  desc "Code converter on tty"
  homepage "https://vmi.jp/software/cygwin/cocot.html"
  url "https://github.com/vmi/cocot/archive/cocot-1.1-20120313.tar.gz"
  sha256 "bc67576b04a753c49ec563c30fb0cc383e9ce7a3db9295a384b7f77fcc1a57b8"

  head "https://github.com/vmi/cocot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "07cb7945722ff5a3e877f4e992d9ffaf56ed6147422ee2efab58b9cef6416b35" => :sierra
    sha256 "11efeaa69619030b19cbed51861d2af97d0e359bf3cd7d82b58af56e081911ae" => :el_capitan
    sha256 "13cef35dc54d9715956e142ee7a4cc2dfae1a50276f111d595057654099db80b" => :yosemite
    sha256 "307edb7057d0c5601ad9e1d9ad65cb15fd7416304b565deac6929e95f2295c74" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end

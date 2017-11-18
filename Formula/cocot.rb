class Cocot < Formula
  desc "Code converter on tty"
  homepage "https://vmi.jp/software/cygwin/cocot.html"
  url "https://github.com/vmi/cocot/archive/cocot-1.2-20171118.tar.gz"
  sha256 "b718630ce3ddf79624d7dcb625fc5a17944cbff0b76574d321fb80c61bb91e4c"

  head "https://github.com/vmi/cocot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2631b1aa093e76762204fb074f9999a80c6416d1ffec39a0b465356fed4e908f" => :high_sierra
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

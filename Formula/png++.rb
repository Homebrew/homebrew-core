class Pngxx < Formula
  desc "C++ wrapper for libpng library"
  homepage "https://www.nongnu.org/pngpp/"
  url "https://savannah.nongnu.org/download/pngpp/png++-0.2.5.tar.gz"
  sha256 "339fa2dff2cdd117efb43768cb272745faef4d02705b5e0e840537a2c1467b72"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "4085580bff1ec2116c321e84a426d195943a002f84b4662c9814a64e5925c627" => :high_sierra
    sha256 "41785b523dc50e5b237d83d027b34b6532114a6751eff3f409ee0ba9e0730f04" => :sierra
    sha256 "7b01b3ff0af9e60f2887bb45ff5ba2f5823a9a440c2d78e51e69904d3edd80d8" => :el_capitan
    sha256 "de37d7fadb7308b45ba0448308256d00bf36442bacbab1e734ee8398aea8a8dd" => :yosemite
    sha256 "f2e242ee428f191645418a9897eb2fd729408dd67d04e7af4cefc7dcb5715250" => :mavericks
  end

  depends_on "libpng"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end
end

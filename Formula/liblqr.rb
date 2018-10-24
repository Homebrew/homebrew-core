class Liblqr < Formula
  desc "C/C++ seam carving library"
  homepage "https://liblqr.wikidot.com/"
  url "https://liblqr.wdfiles.com/local--files/en:download-page/liblqr-1-0.4.2.tar.bz2"
  version "0.4.2"
  sha256 "173a822efd207d72cda7d7f4e951c5000f31b10209366ff7f0f5972f7f9ff137"
  head "https://repo.or.cz/liblqr.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e4823b883ffc65f35e9404499fa0293e7c1b1559f0b4a6bda8393cb018736f23" => :mojave
    sha256 "b54e684b469c952a453ec72ca7e8559198b2de0bf0b7a572b7191f266bbcda41" => :high_sierra
    sha256 "ce5899d11af881965bed731baac1ef6f35e77bf5d4daa1e0fa579e90b82e3d35" => :sierra
    sha256 "9d47668f2c1b428499931a32bcb55c957d837e677ce14215cd4d9a674eff1485" => :el_capitan
    sha256 "a0f647159bd2c17e449381c67b5e4718b3629196bbf71da999a852794899fe67" => :yosemite
    sha256 "5912e95a5c22808ee83053af73817b5514708bb0a9c9549ac2e819f20676e941" => :mavericks
    sha256 "61c2f4e9ed619d0995ddd160cf50f9219aa1dbbbaea717372d8197572a79c112" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

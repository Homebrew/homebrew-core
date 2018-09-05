class Garmintools < Formula
  desc "Interface to the Garmin Forerunner GPS units"
  homepage "https://code.google.com/archive/p/garmintools/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/garmintools/garmintools-0.10.tar.gz"
  sha256 "ffd50b7f963fa9b8ded3223c4786b07906c887ed900de64581a24ff201444cee"

  bottle do
    cellar :any
    sha256 "ee15b7a5ca1312a9ed358f22ce2c36681eedda24ae7b855b079f196e39280101" => :mojave
    sha256 "9ecdb8294089c84a229db39a395bf3f4817f185f30135a6f92711b95705ab869" => :high_sierra
    sha256 "c747a668400406f6625a3832e351a4f27fd1308d8ef840120eba086d3d6adcb4" => :sierra
    sha256 "dd86a8e306d3c4ebb9b94ddd4aaf60fdb79aa06fc7eb56ca95942248db33924e" => :el_capitan
    sha256 "62d2b45ae3d7ef7de9a8deaa658e12021f16b14008f1a91e8c747f84b0e803d3" => :yosemite
    sha256 "bdd96fdc8cf79cde06b330855d7899539816d08cc3b815a0ee115289cac6e30b" => :mavericks
  end

  depends_on "libusb-compat"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"garmin_dump"
  end
end

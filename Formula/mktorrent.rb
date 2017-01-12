class Mktorrent < Formula
  desc "Create BitTorrent metainfo files"
  homepage "http://mktorrent.sourceforge.net/"
  url "https://github.com/Rudde/mktorrent/archive/v1.1.tar.gz"
  sha256 "d0f47500192605d01b5a2569c605e51ed319f557d24cfcbcb23a26d51d6138c9"

  bottle do
    cellar :any
    sha256 "d465e987b90707240ee59118fb719fef082a16261924449309a009abb6b6dae4" => :sierra
    sha256 "4e1fbfdfd5bcd1f4ae28e07f2955eb34e785a72b5e93ef23ac5ae733b4f36a22" => :el_capitan
    sha256 "afd5e147727bc83fcde127e06f244513708045a295976d6571c23ee704f618f0" => :yosemite
    sha256 "79d448b9d2272a350d423668675a6b1504302505ae94af99f2a780efd0b82958" => :mavericks
    sha256 "7f9b38afb40e0f2fe2cde8209f942fa9c1367407593ef64cffc4996a49e97329" => :mountain_lion
  end

  depends_on "openssl"

  def install
    system "make", "USE_PTHREADS=1", "USE_OPENSSL=1", "USE_LONG_OPTIONS=1"
    bin.install "mktorrent"
  end
end

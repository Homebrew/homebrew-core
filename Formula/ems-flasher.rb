class EmsFlasher < Formula
  desc "Software for flashing the EMS Gameboy USB cart"
  homepage "https://lacklustre.net/projects/ems-flasher/"
  url "https://lacklustre.net/projects/ems-flasher/ems-flasher-0.03.tgz"
  sha256 "d77723a3956e00a9b8af9a3545ed2c55cd2653d65137e91b38523f7805316786"

  bottle do
    cellar :any
    sha256 "708f7bfd2d48d73df85cb8a90f183197e1ebcd3da3be013eedd2bf236d0eaddb" => :catalina
    sha256 "f14a792cca1e617dec44e6f11ec413aabbb027097f833ec3a70389bf02da37a5" => :mojave
    sha256 "188c1755cfe1e45fbfb7350e7fc9d546668438d3d0647c044a681eeef868d85e" => :high_sierra
    sha256 "51ac3640147a25c8cf9f1177c2f3c430fa3c6a95d75022544eea825b14934593" => :sierra
    sha256 "2be0a155a5442879c3cfa7a804e125be814bb3d1b5c002326a33e0b84ce6024b" => :el_capitan
    sha256 "3f978e8b96d4c1f0464ce2d4af86ff5bac6cb60810e1b8d81ce4fe55bb2abb63" => :yosemite
  end

  head do
    url "https://github.com/mikeryan/ems-flasher.git"
    depends_on "coreutils" => :build
    depends_on "gawk" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    if build.head?
      system "./config.sh", "--prefix", prefix
      man1.mkpath
      system "make", "install"
    else
      system "make"
      bin.install "ems-flasher"
    end
  end

  test do
    system "#{bin}/ems-flasher", "--version"
  end
end

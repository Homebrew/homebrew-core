class EmsFlasher < Formula
  desc "Software for flashing the EMS Gameboy USB cart"
  homepage "https://lacklustre.net/projects/ems-flasher/"
  url "https://lacklustre.net/projects/ems-flasher/ems-flasher-0.03.tgz"
  sha256 "d77723a3956e00a9b8af9a3545ed2c55cd2653d65137e91b38523f7805316786"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c466c77b30d2f12a642f70ac295bd92f1c212a02f91902cbd3a538e1b4b43849"
    sha256 cellar: :any,                 arm64_big_sur:  "f9b941615f6337e331ab3382c659eafb4548af8a5c8977d042c1a4b4ed5549b1"
    sha256 cellar: :any,                 monterey:       "18fabb4f830e3bd8b48f170d173feb47b13f50ab4470e626bec27680c17c4ed2"
    sha256 cellar: :any,                 big_sur:        "7265467864beba18015da5596e84e8cc969fe1860601036b342f12913043200f"
    sha256 cellar: :any,                 catalina:       "708f7bfd2d48d73df85cb8a90f183197e1ebcd3da3be013eedd2bf236d0eaddb"
    sha256 cellar: :any,                 mojave:         "f14a792cca1e617dec44e6f11ec413aabbb027097f833ec3a70389bf02da37a5"
    sha256 cellar: :any,                 high_sierra:    "188c1755cfe1e45fbfb7350e7fc9d546668438d3d0647c044a681eeef868d85e"
    sha256 cellar: :any,                 sierra:         "51ac3640147a25c8cf9f1177c2f3c430fa3c6a95d75022544eea825b14934593"
    sha256 cellar: :any,                 el_capitan:     "2be0a155a5442879c3cfa7a804e125be814bb3d1b5c002326a33e0b84ce6024b"
    sha256 cellar: :any,                 yosemite:       "3f978e8b96d4c1f0464ce2d4af86ff5bac6cb60810e1b8d81ce4fe55bb2abb63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8081dea4fbc1c501388ffb3a38751d47a09ef38b0dacd3e09ad7995f66c9249a"
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

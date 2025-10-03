class EmsFlasher < Formula
  desc "Software for flashing the EMS Gameboy USB cart"
  homepage "https://lacklustre.net/projects/ems-flasher/"
  url "https://lacklustre.net/projects/ems-flasher/ems-flasher-0.03.tgz"
  sha256 "d77723a3956e00a9b8af9a3545ed2c55cd2653d65137e91b38523f7805316786"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?ems-flasher[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "a7f24072022ccf384517e60b21fe3d5c4f32290601710f0149362eb6bf9b9723"
    sha256 cellar: :any,                 arm64_sequoia:  "3234b5a7a065c25076109874fb9f7f4c4a43b87f758320145eed22b186be84d3"
    sha256 cellar: :any,                 arm64_sonoma:   "92132e129a5b7ef2267791b3ff632cd211b461f75a7f0bb9d123fadfb53df0d6"
    sha256 cellar: :any,                 arm64_ventura:  "54d3c6be5cc7988fd0a6e5ef40f855704ee68e934ceb7fd26e6d7007152db088"
    sha256 cellar: :any,                 arm64_monterey: "c466c77b30d2f12a642f70ac295bd92f1c212a02f91902cbd3a538e1b4b43849"
    sha256 cellar: :any,                 arm64_big_sur:  "f9b941615f6337e331ab3382c659eafb4548af8a5c8977d042c1a4b4ed5549b1"
    sha256 cellar: :any,                 sonoma:         "f0330f1a9397a958ecefcef656f7c93e6b901c37013f226560780adff292df0a"
    sha256 cellar: :any,                 ventura:        "bbae7536369f11050b3c97fc86e299370174f3639c2d962508751b472311f1e6"
    sha256 cellar: :any,                 monterey:       "18fabb4f830e3bd8b48f170d173feb47b13f50ab4470e626bec27680c17c4ed2"
    sha256 cellar: :any,                 big_sur:        "7265467864beba18015da5596e84e8cc969fe1860601036b342f12913043200f"
    sha256 cellar: :any,                 catalina:       "708f7bfd2d48d73df85cb8a90f183197e1ebcd3da3be013eedd2bf236d0eaddb"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "afe3f200bc7c6b136eef20237168d892b9201dd6bd1a70178f0ca1a8c3371a24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8081dea4fbc1c501388ffb3a38751d47a09ef38b0dacd3e09ad7995f66c9249a"
  end

  head do
    url "https://github.com/mikeryan/ems-flasher.git", branch: "master"
    depends_on "coreutils" => :build
    depends_on "gawk" => :build
  end

  depends_on "pkgconf" => :build
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
    system bin/"ems-flasher", "--version"
  end
end
